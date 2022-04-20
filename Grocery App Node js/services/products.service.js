const { product } = require("../models/product.model");
const { category } = require("../models/category.model");

const { MONGO_DB_CONFIG } = require("../config/app.config");

async function createProduct(params, callback) {
    if (!params.productName) {
        return callback(
            {
                message: "Product Name required",
            },
            ""
        )
    }
    if (!params.category) {
        return callback(
            {
                message: "category required",
            },
            ""
        )
    }
    const productModel = new product(params);
    productModel.save()
        .then((response) => {
            return callback(null, response);
        })
        .catch((error) => {
            return callback(error);
        });
}

async function getProducts(params, callback) {
    const productName = params.productName;
    const categoryId = params.categoryId;
    var condition = {};
    if (productName) {
        condition["productName"] = {
            $regex: new RegExp(productName), $options: "i"
        };
    }
    if (categoryId) {
        condition["category"] = categoryId;
    }
    if(params.productIds){
        condition["_id"]={
            $in:params.productIds.split(",")
        }
    }

    let perPage = Math.abs(params.pageSize) || MONGO_DB_CONFIG.PAGE_SIZE;
    let page = (Math.abs(params.page) || 1) - 1;

    product
        .find(condition, "productId productName productShortDescription productDescription productPrice productSalePrice productImage productSKU productType stockStatus createdAt updatedAt")
        .sort(params.sort)
        .populate("category", "categoryName categoryImage")
        .populate("relatedProduct", "relatedProduct")
        .limit(perPage)
        .skip(perPage * page)
        .then((response) => {
            var res=response.map(r=>{
                if(r.relatedProduct.length>0){
                    r.relatedProduct=r.relatedProduct.map(x=>x.relatedProduct);
                }
                return r;
            });
            return callback(null, res);
        })
        .catch((error) => {
            return callback(error);
        });
}
async function getProductById(params, callback) {
    const productId = params.productId;
    product
    .findById(productId)
       
        .populate("category", "categoryName productImage")
        .populate( "relatedProduct", "relatedProduct")
        .then((response) => {
            response.relatedProduct=response.relatedProduct.map(x=>{
                return x.relatedProduct
            });
            return callback(null, response);
        })
        .catch((error) => {
            return callback(error);
        });
}
async function updateProduct(params, callback) {
    const productId = params.productId;
    

    product
    .findByIdAndUpdate(productId,params,{
        useFindAndModify:false
    })
        .then((response) => {
            if(!response){
                callback('Cannot update Product with id '+productId)
            }
            else{
                callback(null, response);
            }
            return callback(null, response);
        })
        .catch((error) => {
            return callback(error);
        });
}
async function deleteProduct(params, callback) {
    const productId = params.productId;
    

    product
    .findByIdAndRemove(productId)
        .then((response) => {
            if(!response){
                callback('Cannot update Product with id '+productId)
            }
            else{
                callback(null, response);
            }
            return callback(null, response);
        })
        .catch((error) => {
            return callback(error);
        });
}
module.exports={
    createProduct,
    getProducts,
    getProductById,
    updateProduct,
    deleteProduct,
}