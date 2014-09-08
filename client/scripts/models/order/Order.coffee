Order = (Restangular)=>
  all = ()=>
  find = (id)=>
  create = (data)=>
  update = (id, data)=>
  destory = (id)=>

Order.$inject = ['Restangular']
angular
  .module('app.models.oder')
  .factory('Order', Order)

