#if defined(QCHAT_LIBRARY)
#  define QCHAT_EXPORT Q_DECL_EXPORT
#else
#  define QCHAT_EXPORT Q_DECL_IMPORT
#endif
