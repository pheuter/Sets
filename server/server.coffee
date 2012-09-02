Sets   = new Meteor.Collection "sets"
Photos = new Meteor.Collection "photos"

Meteor.startup ->
  Meteor.publish "sets", ->
    Sets.find()
    
  Meteor.publish "photos", (set) ->
    Photos.find set: set