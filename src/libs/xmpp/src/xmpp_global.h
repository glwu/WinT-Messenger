#if defined(XMPP_LIBRARY)
#  define XMPP_EXPORT Q_DECL_EXPORT
#else
#  define XMPP_EXPORT Q_DECL_IMPORT
#endif
