function errorHandler(err, req, res, next) {
    if (typeof err === "string") {
        return err.status(400).json({ message: err });
    }

    if (err.name === "ValidationError") {
        return err.status(400).json({ message: err.message });
    }

    if(err.name==="UnauthorizedError"){
        return err.status(401).json({ message: err.message });

    }

    return res.status(500).json({ message: err.message });
}
module.exports = {
    errorHandler,
}