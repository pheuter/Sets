Sets = new Meteor.Collection "sets"
Photos = new Meteor.Collection "photos"

Meteor.autosubscribe ->
  Meteor.subscribe "photos", Session.get "set"
Meteor.subscribe "sets"  

Template.side.events = 
  'submit #new-set': (e,t) ->
    e.preventDefault()
    
    if Sets.find(name: t.find('#set-name').value).count()
      alert "Set already exists!"
    else
      Sets.insert
        name: t.find('#set-name').value
        time: (new Date).getTime()
        
        
  'click .set': (e,t) ->
    window.location.href = "/set/#{e.target.innerText}"
    
    
Template.side.sets = ->
  Sets.find({},
    sort: time: -1
  ).fetch()
  
  
Template.main.events = 
  'click #upload': (e,t) ->
    filepicker.getFile 'image/*', multiple: true, persist: true, (uploads) ->
      _.each uploads, (image) ->
        Photos.insert
          set: Session.get "set"
          name: image.data.filename
          url: image.url
          time: (new Date).getTime()
        
  
Template.main.set = ->
  Session.get "set"  
  

Template.main.photos = ->
  Photos.find(
    {set: Session.get "set"},
    sort: time: -1
  )
  



AppRouter = Backbone.Router.extend
  routes:
    "": "main"
    "set/:name": "set"

  main:  ->
    Session.set "set", null
    
  set: (name) ->
    Session.set "set", name    
    
  
Router = new AppRouter
Meteor.startup ->  
  filepicker.setKey 'ACSqjiD5pQAmoP5oCArRsz'
  Backbone.history.start pushState: true  