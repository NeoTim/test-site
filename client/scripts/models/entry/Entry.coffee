Entry = (Restangular)=>

  assign = (id, user_id)=>
    # Restangular.one('entries', id).put()
  batch = (id, batch_id)=>

  all = ()=>
  find = ()=>
  create = ()=>
  update = ()=>
  destroy = ()=>

Entry.$inject = [
  'Restangular'
]
angular
  .module('app.models')
  .factory('Entry', Entry)


