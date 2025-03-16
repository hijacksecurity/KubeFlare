from config.config import Config

class ProdConfig(Config):
    # Production-specific settings
    DEBUG = False
    ENV = 'PROD'