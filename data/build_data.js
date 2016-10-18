var fs = require("fs");
var Promise = require("promise");
var writeFile = Promise.denodeify(require('fs').writeFile);
var gcloud = require("google-cloud");
var languageClient = gcloud.language({
  projectId: "in-full-gear",
  keyFilename: __dirname + "/../secret/auth_key.json"
});
var data_array = require(__dirname + "/data.json").slice(0,2);
var output_file = __dirname + "/full_data.json";

function getSentiment(content){
  console.log("Resolve sentiment of %s", content.substring(0, 5) + "...");
  return new Promise(function (resolve, reject){
    var doc = languageClient.document({content : content, type:"text"});
    return doc.detectSentiment({verbose : true},function(err, sentiment){
      if(err){
        return reject(err);
      }
      resolve(sentiment);
    });
  });
}

function getEntities(content){
  console.log("Resolve entities of %s", content.substring(0, 5) + "...");
  return new Promise(function (resolve, reject){
    var doc = languageClient.document({content : content, type:"text"});
    return doc.detectEntities({verbose : true},function(err, entities){
      if(err){
        return reject(err);
      }
      resolve(entities);
    });
  });
}

Promise.resolve(0).then(function traverse(index){
  if(index === data_array.length)
    return writeFile(output_file, JSON.stringify(data_array));
  var content = data_array[index].msg;
  return getEntities(content).then(function done(entities){
    data_array[index].entities = entities;
    return getSentiment(content);
  }, function fail(err){
    return Promise.reject(err);
  }).then(function done(sentiment){
    data_array[index].sentiment = sentiment;
    return traverse(index + 1);
  }, function fail(err){
    return Promise.reject(err);
  })
}).then(function done(){
  console.log("the job has been completed!");
}, function fail(err){
  console.log("error %s happened along the way!", err);
});
