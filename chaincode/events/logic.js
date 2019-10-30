'use strict';
const { Contract} = require('fabric-contract-api');

class eventLogs extends Contract {

   async logEvents(ctx,productId) {
   
    let logsAsBytes = await ctx.stub.getState(productId); 
    if (!logsAsBytes || logsAsBytes.toString().length <= 0) {
      return("Error:Logs With this ProductId does not exist..!");
       }
    
    else{
     let logs=JSON.parse(logsAsBytes.toString());
     return JSON.stringify(logs);
     }
 }
    
    async submitProduct(ctx,productId,ownerName,productName) {
   
    let productAsBytes = await ctx.stub.getState(productId); 
    if (!productAsBytes || productAsBytes.toString().length <= 0) {
      let productData={
           ProductId:productId,
           ProductName:productName,
           Owner:ownerName,
           Logs:[],
           CurrentStatus:'Submitted'
           };
      let timeStamp= await ctx.stub.getTxTimestamp();
      const timestamp = new Date(timeStamp.getSeconds() * 1000).toISOString();

      let logData={
           Timestamp:timestamp,
           Status:'Submitted'
           };
    
     productData.Logs.push(logData);

     await ctx.stub.putState(productId,Buffer.from(JSON.stringify(productData))); 
     console.log('Product Submission event added To the ledger Succesfully..');
     return('Product Submission event added To the ledger Succesfully..');
     }
     else {

      return('Error:Product With this Id Already Exists.!');
     }
  }

  async addEvent(ctx,productId, status){

   let productAsBytes = await ctx.stub.getState(productId); 
    if (!productAsBytes || productAsBytes.toString().length <= 0) {
    return('Error:Product With This Id does not exist..')
     }
    else {
    
    let timeStamp= await ctx.stub.getTxTimestamp();
    const timestamp = new Date(timeStamp.getSeconds() * 1000).toISOString();

      let logData={
           Timestamp:timestamp,
           Status:status
            };
        let product = JSON.parse(productAsBytes);
        product.Logs.push(logData);
        product.CurrentStatus=status;

       await ctx.stub.putState(productId,Buffer.from(JSON.stringify(product))); 
       console.log('Product event added To the ledger Succesfully..');
       return('Product event added To the ledger Succesfully..');
       }

    }
}

module.exports=eventLogs;
