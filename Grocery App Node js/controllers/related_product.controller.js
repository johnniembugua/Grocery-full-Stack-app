const relatedProductServices = require('../services/related_product.service');

exports.create=(req,res,next)=>{
    relatedProductServices.addRelatedProduct(req.body,(err,results)=>{
        if(err){
            return next(err);
        }
        return res.status(200).send({
            message:"success",
            data:results
        })
    });

};

exports.delete=(req,res,next)=>{
    var model={
        id:req.params.id
    };
    relatedProductServices.removeRelatedProduct(model,(err,results)=>{
        if(err){
            return next(err);
        }
        return res.status(200).send({
            message:"success",
            data:results
        })
    });
};