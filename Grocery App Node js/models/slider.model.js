const mongoose = require("mongoose");

const slider = mongoose.model(
    "Sliders",
    mongoose.Schema({
        sliderName: {
            type: String,
            required: true,
            unique: true,
        },
        sliderDescription: {
            type: String,
            required: false,

        },
        sliderURL: {
            type: String,
            required: false,

        },
        sliderImage: {
            type: String,
            required: true,

        }

    },
    { toJSON:{
        transform:function(doc,ret){
            ret.sliderId=ret._id.toString();
            delete ret._id;
            delete ret.__v;
        }
    }
}
    
    )
);

module.exports = {
    slider,
}