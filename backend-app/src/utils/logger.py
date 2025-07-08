import logging
import sys
import os

# Sólo para debug.
logger = logging.getLogger("flask_app")
log_level = os.environ.get("LOG_LEVEL", "DEBUG").upper()
logger.setLevel(getattr(logging, log_level, logging.DEBUG))

handler = logging.StreamHandler(sys.stdout)
handler.setLevel(getattr(logging, log_level, logging.DEBUG))

formatter = logging.Formatter("[%(asctime)s] [%(levelname)s] %(message)s", "%Y-%m-%d %H:%M:%S")
handler.setFormatter(formatter)

if not logger.hasHandlers():
    logger.addHandler(handler)