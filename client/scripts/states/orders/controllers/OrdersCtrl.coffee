'use strict'
OrdersCtrl = (Orders)=>
  # console.log(Orders)
  @initialize = =>
    $scope.orders = Orders.get()

  @initialize()
  console.log(@orders)

  return


Orders = ()=>
  orders = [
    {number: 1, customer: 'Waste Quip', date: '9/1/2014'}
    {number: 2, customer: 'Waste Quip Durant', date: '9/1/2014'}
    {number: 3, customer: 'Waste Quip Lakeland', date: '9/1/2014'}
    {number: 4, customer: 'Waste Quip Ohio', date: '9/1/2014'}
  ]
  get = ->
    return orders
  find = (id)->
    return _(orders).where({id: id})[0]

  create = ->
  update = ->
  destroy = ->

  return {
    get: get,
    find: find,
    create: create,
    update: update,
    destroy: destroy
  }

angular
  .module('app.states.orders')
  .controller('OrdersCtrl', OrdersCtrl)
  .factory('Orders', Orders)

