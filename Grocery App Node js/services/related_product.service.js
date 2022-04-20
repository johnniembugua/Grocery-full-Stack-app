const { related_product, relatedProduct } = require("../models/related_product.model");
const { product } = require("../models/product.model");

async function addRelatedProduct(params, callback) {
    if (!params.product) {
        callback({
            message: "Product is required"
        });
    }
    if (!params.relatedProduct) {
        callback({
            message: "RelatedProduct is required"
        });
    }
    const relatedProductModel = new relatedProduct(params);
    relatedProductModel.save()
        .then(async (response) => {
            await product.findOneAndUpdate(
                {
                    _id: params.product
                },
                {
                    $addToSet: {
                        "relatedProduct": relatedProductModel
                    }
                }
            );
            return callback(null, response);
        })
        .catch((error) => {
            return callback(error);
        });
}

async function removeRelatedProduct(params,callback){

    const d =params.id;

    relatedProduct.findByIdAndRemove(id)
    .then((response)=>{
        if(!response){
            return callback({
                message:"Related Product not found"
            });
        }
        else{
            return callback(null,response);
        }
    })
    .catch((error)=>{
        return callback(error);
    })

}

module.exports={
    addRelatedProduct,
    removeRelatedProduct
}