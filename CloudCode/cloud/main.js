
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
                   response.success("Hello world!");
                   });

Parse.Cloud.define("reportUser", function(request, response) {
                   var userId = request.params.userId;
                   
                   var User = Parse.Object.extend('_User'),
                   user = new User({ objectId: userId });
                   
                   user.set('reported', true);
                   
                   Parse.Cloud.useMasterKey();
                   user.save().then(function(user) {
                                    response.success(user);
                                    }, function(error) {
                                    response.error(error)
                                    });
                   });

Parse.Cloud.afterSave("response", function(request) {
                      var query = new Parse.Query("response");
                      var question = request.object.get("question");
                      query.equalTo("question", question);
                      query.find({
                                 success: function(results) {
                                 if (results.length == 25) {
                                 question.fetch({
                                                success: function(question) {
                                                
                                                console.log("this is the object " + question + " value for creator " + question.get("creator").id);
                                                
                                                // Build a query to match users with a birthday today
                                                var innerQuery = new Parse.Query(Parse.User);
                                                
                                                // Use hasPrefix: to only match against the month/date
                                                innerQuery.equalTo("objectId", question.get("creator").id);
                                                
                                                // Build the actual push notification target query
                                                var pushQuery = new Parse.Query(Parse.Installation);
                                                pushQuery.matchesQuery("user", innerQuery);
                                                
                                                Parse.Push.send({
                                                                where:pushQuery,
                                                                data: {
                                                                alert: "You have a question that has been answered!"
                                                                }
                                                                });
                                                }
                                                });
                                 }
                                 
                                 
                                 },
                                 error: function(error) {
                                 alert("Error: " + error.code + " " + error.message);
                                 }
                                 });
                      
                      
                      
                      });
