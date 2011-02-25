/*
 * Copyright (c) 2004-2009 Sergey Lyubka
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * $Id: mongoose.h 404 2009-05-28 10:05:48Z valenok $
 */

#ifndef MONGOOSE_HEADER_INCLUDED
#define	MONGOOSE_HEADER_INCLUDED

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

struct mg_context;	/* Handle for the HTTP service itself	*/
struct mg_connection;	/* Handle for the individual connection	*/


/*
 * This structure contains full information about the HTTP request.
 * It is passed to the user-specified callback function as a parameter.
 */
struct mg_request_info {
	char	*request_method;	/* "GET", "POST", etc	*/
	char	*uri;			/* Normalized URI	*/
	char	*query_string;		/* \0 - terminated	*/
	char	*post_data;		/* POST data buffer	*/
	char	*remote_user;		/* Authenticated user	*/
	long	remote_ip;		/* Client's IP address	*/
	int	remote_port;		/* Client's port	*/
	int	post_data_len;		/* POST buffer length	*/
	int	http_version_major;
	int	http_version_minor;
	int	status_code;		/* HTTP status code	*/
	int	num_headers;		/* Number of headers	*/
	struct mg_header {
		char	*name;		/* HTTP header name	*/
		char	*value;		/* HTTP header value	*/
	} http_headers[64];		/* Maximum 64 headers	*/
};


/*
 * User-defined callback function prototype for URI handling, error handling,
 * or logging server messages.
 */
typedef void (*mg_callback_t)(struct mg_connection *,
		const struct mg_request_info *info, void *user_data);


/*
 * Start the web server.
 * This must be the first function called by the application.
 * It creates a serving thread, and returns a context structure that
 * can be used to alter the configuration, and stop the server.
 */
struct mg_context *mg_start(void);


/*
 * Stop the web server.
 * Must be called last, when an application wants to stop the web server and
 * release all associated resources. This function blocks until all Mongoose
 * threads are stopped. Context pointer becomes invalid.
 */
void mg_stop(struct mg_context *);


/*
 * Return current value of a particular option.
 */
const char *mg_get_option(const struct mg_context *, const char *option_name);


/*
 * Set a value for a particular option.
 * Mongoose makes an internal copy of the option value string, which must be
 * valid nul-terminated ASCII or UTF-8 string. It is safe to change any option
 * at any time. The order of setting various options is also irrelevant with
 * one exception: if "ports" option contains SSL listening ports, a "ssl_cert"
 * option must be set BEFORE the "ports" option.
 * Return value:
 *	-1 if option is unknown
 *	0  if mg_set_option() failed
 *	1  if mg_set_option() succeeded 
 */
int mg_set_option(struct mg_context *, const char *opt_name, const char *value);


/*
 * Add, edit or delete the entry in the passwords file.
 * This function allows an application to manipulate .htpasswd files on the
 * fly by adding, deleting and changing user records. This is one of the two
 * ways of implementing authentication on the server side. For another,
 * cookie-based way please refer to the examples/authentication.c in the
 * source tree.
 * If password is not NULL, entry is added (or modified if already exists).
 * If password is NULL, entry is deleted. Return:
 *	1 on success
 *	0 on error 
 */
int mg_modify_passwords_file(struct mg_context *ctx, const char *file_name,
		const char *user_name, const char *password);


/*
 * Register URI handler.
 * It is possible to handle many URIs if using * in the uri_regex, which
 * matches zero or more characters. user_data pointer will be passed to the
 * handler as a third parameter. If func is NULL, then the previously installed
 * handler for this uri_regex is removed.
 */
void mg_set_uri_callback(struct mg_context *ctx, const char *uri_regex,
		mg_callback_t func, void *user_data);


/*
 * Register HTTP error handler.
 * An application may use that function if it wants to customize the error
 * page that user gets on the browser (for example, 404 File Not Found message).
 * It is possible to specify a error handler for all errors by passing 0 as
 * error_code. That '0' error handler must be set last, if more specific error
 * handlers are also used. The actual error code value can be taken from
 * the request info structure that is passed to the callback.
 */
void mg_set_error_callback(struct mg_context *ctx, int error_code,
		mg_callback_t func, void *user_data);


/*
 * Register authorization handler.
 * This function provides a mechanism to implement custom authorization,
 * for example cookie based (look at examples/authorization.c).
 * The callback function must analyze the request, and make its own judgement
 * on wether it should be authorized or not. After the decision is made, a
 * callback must call mg_authorize() if the request is authorized.
 */
void mg_set_auth_callback(struct mg_context *ctx, const char *uri_regex,
		mg_callback_t func, void *user_data);


/*
 * Register log handler.
 * By default, Mongoose logs all error messages to stderr. If "error_log"
 * option is specified, the errors are written in the specified file. However,
 * if an application registers its own log handler, Mongoose will not log
 * anything but call the handler function, passing an error message as
 * "user_data" callback argument.
 */
void mg_set_log_callback(struct mg_context *ctx, mg_callback_t func);


/*
 * Register SSL password handler.
 * This is needed only if SSL certificate asks for a password. Instead of
 * prompting for a password on a console a specified function will be called.
 */
typedef int (*mg_spcb_t)(char *buf, int num, int w, void *key);
void mg_set_ssl_password_callback(struct mg_context *ctx, mg_spcb_t func);


/*
 * Send data to the browser.
 * Return number of bytes sent. If the number of bytes sent is less then
 * requested or equals to -1, network error occured, usually meaning the
 * remote side has closed the connection.
 */
int mg_write(struct mg_connection *, const void *buf, int len);


/*
 * Send data to the browser using printf() semantics.
 * Works exactly like mg_write(), but allows to do message formatting.
 * Note that mg_printf() uses internal buffer of size MAX_REQUEST_SIZE
 * (8 Kb by default) as temporary message storage for formatting. Do not
 * print data that is bigger than that, otherwise it will be truncated.
 * Return number of bytes sent.
 */
int mg_printf(struct mg_connection *, const char *fmt, ...);


/*
 * Get the value of particular HTTP header.
 * This is a helper function. It traverses request_info->http_headers array,
 * and if the header is present in the array, returns its value. If it is
 * not present, NULL is returned.
 */
const char *mg_get_header(const struct mg_connection *, const char *hdr_name);


/*
 * Authorize the request.
 * See the documentation for mg_set_auth_callback() function.
 */
void mg_authorize(struct mg_connection *);


/*
 * Get a value of particular form variable.
 * Both query string (whatever comes after '?' in the URL) and a POST buffer
 * are scanned. If a variable is specified in both query string and POST
 * buffer, POST buffer wins. Return value:
 *	NULL      if the variable is not found
 *	non-NULL  if found. NOTE: this returned value is dynamically allocated
 *		  and is subject to mg_free() when no longer needed. It is
 *		  an application's responsibility to mg_free() the variable. 
 */
char *mg_get_var(const struct mg_connection *, const char *var_name);


/*
 * Free up memory returned by mg_get_var().
 */
void mg_free(char *var);


/*
 * Return Mongoose version.
 */
const char *mg_version(void);


/*
 * Print command line usage string.
 */
void mg_show_usage_string(FILE *fp);

#include <stdint.h>
#include <time.h>
#include <sys/socket.h>
#include <arpa/inet.h>
	
	typedef int bool_t;
	
	/*
	 * Structure used by mg_stat() function. Uses 64 bit file length.
	 */
	struct mgstat {
		bool_t		is_directory;	/* Directory marker		*/
		uint64_t	size;		/* File size			*/
		time_t		mtime;		/* Modification time		*/
	};
	
	/*
	 * Darwin prior to 7.0 and Win32 do not have socklen_t
	 */
#ifdef NO_SOCKLEN_T
	typedef int socklen_t;
#endif /* NO_SOCKLEN_T */
	
#define	MONGOOSE_VERSION	"2.8"
#define	PASSWORDS_FILE_NAME	".htpasswd"
#define	CGI_ENVIRONMENT_SIZE	4096
#define	MAX_CGI_ENVIR_VARS	64
#define	MAX_REQUEST_SIZE	8192
#define	MAX_LISTENING_SOCKETS	10
#define	MAX_CALLBACKS		20
#define	ARRAY_SIZE(array)	(sizeof(array) / sizeof(array[0]))
#define	UNKNOWN_CONTENT_LENGTH	((uint64_t) ~0)
#define	DEBUG_MGS_PREFIX	"*** Mongoose debug *** "
	/*
	 * Snatched from OpenSSL includes. I put the prototypes here to be independent
	 * from the OpenSSL source installation. Having this, mongoose + SSL can be
	 * built on any system with binary SSL libraries installed.
	 */
	typedef struct ssl_st SSL;
	typedef struct ssl_method_st SSL_METHOD;
	typedef struct ssl_ctx_st SSL_CTX;
	
#define	SSL_ERROR_WANT_READ	2
#define	SSL_ERROR_WANT_WRITE	3
#define SSL_FILETYPE_PEM	1
#define	CRYPTO_LOCK		1
	
	/*
	 * Dynamically loaded SSL functionality
	 */
	struct ssl_func {
		const char	*name;		/* SSL function name	*/
		void		(*ptr)(void);	/* Function pointer	*/
	};
	
#define	SSL_free(x)	(* (void (*)(SSL *)) ssl_sw[0].ptr)(x)
#define	SSL_accept(x)	(* (int (*)(SSL *)) ssl_sw[1].ptr)(x)
#define	SSL_connect(x)	(* (int (*)(SSL *)) ssl_sw[2].ptr)(x)
#define	SSL_read(x,y,z)	(* (int (*)(SSL *, void *, int)) 		\
ssl_sw[3].ptr)((x),(y),(z))
#define	SSL_write(x,y,z) (* (int (*)(SSL *, const void *,int))		\
ssl_sw[4].ptr)((x), (y), (z))
#define	SSL_get_error(x,y)(* (int (*)(SSL *, int)) ssl_sw[5])((x), (y))
#define	SSL_set_fd(x,y)	(* (int (*)(SSL *, SOCKET)) ssl_sw[6].ptr)((x), (y))
#define	SSL_new(x)	(* (SSL * (*)(SSL_CTX *)) ssl_sw[7].ptr)(x)
#define	SSL_CTX_new(x)	(* (SSL_CTX * (*)(SSL_METHOD *)) ssl_sw[8].ptr)(x)
#define	SSLv23_server_method()	(* (SSL_METHOD * (*)(void)) ssl_sw[9].ptr)()
#define	SSL_library_init() (* (int (*)(void)) ssl_sw[10].ptr)()
#define	SSL_CTX_use_PrivateKey_file(x,y,z)	(* (int (*)(SSL_CTX *, \
const char *, int)) ssl_sw[11].ptr)((x), (y), (z))
#define	SSL_CTX_use_certificate_file(x,y,z)	(* (int (*)(SSL_CTX *, \
const char *, int)) ssl_sw[12].ptr)((x), (y), (z))
#define SSL_CTX_set_default_passwd_cb(x,y) \
(* (void (*)(SSL_CTX *, mg_spcb_t)) ssl_sw[13].ptr)((x),(y))
#define SSL_CTX_free(x) (* (void (*)(SSL_CTX *)) ssl_sw[14].ptr)(x)
	
#define CRYPTO_num_locks() (* (int (*)(void)) crypto_sw[0].ptr)()
#define CRYPTO_set_locking_callback(x)					\
(* (void (*)(void (*)(int, int, const char *, int)))	\
crypto_sw[1].ptr)(x)
#define CRYPTO_set_id_callback(x)					\
(* (void (*)(unsigned long (*)(void))) crypto_sw[2].ptr)(x)
	
	/*
	 * set_ssl_option() function when called, updates this array.
	 * It loads SSL library dynamically and changes NULLs to the actual addresses
	 * of respective functions. The macros above (like SSL_connect()) are really
	 * just calling these functions indirectly via the pointer.
	 */
	static struct ssl_func	ssl_sw[] = {
		{"SSL_free",			NULL},
		{"SSL_accept",			NULL},
		{"SSL_connect",			NULL},
		{"SSL_read",			NULL},
		{"SSL_write",			NULL},
		{"SSL_get_error",		NULL},
		{"SSL_set_fd",			NULL},
		{"SSL_new",			NULL},
		{"SSL_CTX_new",			NULL},
		{"SSLv23_server_method",	NULL},
		{"SSL_library_init",		NULL},
		{"SSL_CTX_use_PrivateKey_file",	NULL},
		{"SSL_CTX_use_certificate_file",NULL},
		{"SSL_CTX_set_default_passwd_cb",NULL},
		{"SSL_CTX_free",		NULL},
		{NULL,				NULL}
	};
	
	/*
	 * Similar array as ssl_sw. These functions are located in different lib.
	 */
	static struct ssl_func	crypto_sw[] = {
		{"CRYPTO_num_locks",		NULL},
		{"CRYPTO_set_locking_callback",	NULL},
		{"CRYPTO_set_id_callback",	NULL},
		{NULL,				NULL}
	};
	
	/*
	 * Month names
	 */
	static const char *month_names[] = {
		"Jan", "Feb", "Mar", "Apr", "May", "Jun",
		"Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
	};
	
	/*
	 * Numeric indexes for the option values in context, ctx->options
	 */
	enum mg_option_index {
		OPT_ROOT, OPT_INDEX_FILES, OPT_PORTS, OPT_DIR_LIST, OPT_CGI_EXTENSIONS,
		OPT_CGI_INTERPRETER, OPT_CGI_ENV, OPT_SSI_EXTENSIONS, OPT_AUTH_DOMAIN,
		OPT_AUTH_GPASSWD, OPT_AUTH_PUT, OPT_ACCESS_LOG, OPT_ERROR_LOG,
		OPT_SSL_CERTIFICATE, OPT_ALIASES, OPT_ACL, OPT_UID, OPT_PROTECT,
		OPT_SERVICE, OPT_HIDE, OPT_ADMIN_URI, OPT_MAX_THREADS, OPT_IDLE_TIME,
		OPT_MIME_TYPES,
		NUM_OPTIONS
	};
	
	/*
	 * Unified socket address. For IPv6 support, add IPv6 address structure
	 * in the union u.
	 */
	struct usa {
		socklen_t len;
		union {
			struct sockaddr	sa;
			struct sockaddr_in sin;
		} u;
	};
	
	/*
	 * Specifies a string (chunk of memory).
	 * Used to traverse comma separated lists of options.
	 */
	struct vec {
		const char	*ptr;
		size_t		len;
	};
	
	
	struct mg_option {
		const char	*name;
		const char	*description;
		const char	*default_value;
		int		index;
		bool_t (*setter)(struct mg_context *, const char *);
	};
	
	typedef int SOCKET;
	
	/*
	 * Structure used to describe listening socket, or socket which was
	 * accept()-ed by the master thread and queued for future handling
	 * by the worker thread.
	 */
	struct socket {
		SOCKET		sock;		/* Listening socket		*/
		struct usa	lsa;		/* Local socket address		*/
		struct usa	rsa;		/* Remote socket address	*/
		bool_t		is_ssl;		/* Is socket SSL-ed		*/
	};
	
	/*
	 * Callback function, and where it is bound to
	 */
	struct callback {
		char		*uri_regex;	/* URI regex to handle		*/
		mg_callback_t	func;		/* user callback		*/
		bool_t		is_auth;	/* func is auth checker		*/
		int		status_code;	/* error code to handle		*/
		void		*user_data;	/* opaque user data		*/
	};
	
	/*
	 * Mongoose context
	 */
	struct mg_context {
		int		stop_flag;	/* Should we stop event loop	*/
		SSL_CTX		*ssl_ctx;	/* SSL context			*/
		
		FILE		*access_log;	/* Opened access log		*/
		FILE		*error_log;	/* Opened error log		*/
		
		struct socket	listeners[MAX_LISTENING_SOCKETS];
		int		num_listeners;
		
		struct callback	callbacks[MAX_CALLBACKS];
		int		num_callbacks;
		
		char		*options[NUM_OPTIONS];	/* Configured opions	*/
		pthread_mutex_t	opt_mutex[NUM_OPTIONS];	/* Option protector	*/
		
		int		max_threads;	/* Maximum number of threads	*/
		int		num_threads;	/* Number of threads		*/
		int		num_idle;	/* Number of idle threads	*/
		pthread_mutex_t	thr_mutex;	/* Protects (max|num)_threads	*/
		pthread_cond_t	thr_cond;
		pthread_mutex_t	bind_mutex;	/* Protects bind operations	*/
		
		struct socket	queue[20];	/* Accepted sockets		*/
		int		sq_head;	/* Head of the socket queue	*/
		int		sq_tail;	/* Tail of the socket queue	*/
		pthread_cond_t	empty_cond;	/* Socket queue empty condvar	*/
		pthread_cond_t	full_cond;	/* Socket queue full condvar	*/
		
		mg_spcb_t	ssl_password_callback;
		mg_callback_t	log_callback;
	};
	
	/*
	 * Client connection.
	 */
	struct mg_connection {
		struct mg_request_info	request_info;
		struct mg_context *ctx;		/* Mongoose context we belong to*/
		SSL		*ssl;		/* SSL descriptor		*/
		struct socket	client;		/* Connected client		*/
		time_t		birth_time;	/* Time connection was accepted	*/
		bool_t		free_post_data;	/* post_data was malloc-ed	*/
		bool_t		embedded_auth;	/* Used for authorization	*/
		uint64_t	num_bytes_sent;	/* Total bytes sent to client	*/
	};
	
	int
	mg_stat(const char *path, struct mgstat *stp);
	void
	send_file(struct mg_connection *conn, const char *path, struct mgstat *stp);
	
	
#ifdef __cplusplus
}
#endif /* __cplusplus */


#endif /* MONGOOSE_HEADER_INCLUDED */
