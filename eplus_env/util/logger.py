import logging

class Logger():
    
    def getLogger(self, name, level, formatter):
        logger = logging.getLogger(name);
        consoleHandler = logging.StreamHandler()
        consoleHandler.setFormatter(logging.Formatter(formatter));
        logger.addHandler(consoleHandler);
        logger.setLevel(level);
        logger.propagate = False;
        return logger;