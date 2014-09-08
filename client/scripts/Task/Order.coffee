# angular.module('app.states.orders', [])

'use strict'

angular.module('app')

.factory('orderStorage', ->
  STORAGE_ID = 'orders'
  DEMO_ORDERS = '[
    {"title": "Finish homework", "completed": true},
    {"title": "Make a call", "completed": true},
    {"title": "Build a snowman!", "completed": false},
    {"title": "Tango! Tango! Tango!", "completed": false},
    {"title": "Play games with friends", "completed": false},
    {"title": "Shopping", "completed": false}

  ]'

  return {
    get: ->
      JSON.parse(localStorage.getItem(STORAGE_ID) || DEMO_ORDERS )

    put: (orders)->
      localStorage.setItem(STORAGE_ID, JSON.stringify(orders))
  }
)

# cusor focus when dblclick to edit
.directive('orderFocus', [
  '$timeout'
  ($timeout) ->
    return {
      link: (scope, ele, attrs) ->
        scope.$watch(attrs.orderFocus, (newVal) ->
          if newVal
            $timeout( ->
              ele[0].focus()
            , 0, false)
        )
    }
])

.controller('OrderCtrl', [
  '$scope', 'orderStorage', 'filterFilter', '$rootScope', 'logger'
  ($scope, orderStorage, filterFilter, $rootScope, logger) ->

    orders = $scope.orders = taskStorage.get()

    $scope.newOrder = ''
    $scope.remainingCount = filterFilter(orders, {completed: false}).length
    $scope.editOrder = null
    $scope.statusFilter = {completed: false}

    $scope.filter = (filter) ->
      switch filter
        when 'all' then $scope.statusFilter = ''
        when 'active' then $scope.statusFilter = {completed: false}
        when 'completed' then $scope.statusFilter = {completed: true}

    $scope.add = ->
      newOrder = $scope.newOrder.trim()

      if newOrder.length is 0
        return

      orders.push(
        title: newOrder
        completed: false
      )
      logger.logSuccess('New order: "' + newOrder + '" added')

      orderStorage.put(orders)

      $scope.newOrder = ''
      $scope.remainingCount++

    $scope.edit = (order)->
      $scope.editedOrder = order

    $scope.doneEditing = (order) ->
      $scope.editedOrder = null
      order = order.title.trim()

      if !order.title
        $scope.remove(order)
      else
        logger.log('Order updated')
      orderStorage.put(orders)

    $scope.remove = (order) ->
      $scope.remainingCount -= if order.completed then 0 else 1
      index = $scope.orders.indexOf(order)
      $scope.orders.splice(index, 1)
      orderStorage.put(orders)
      logger.logError('Order removed')

    $scope.completed = (order) ->
      $scope.remainingCount += if order.completed then -1 else 1
      orderStorage.put(order)
      if order.completed
        if $scope.remainingCount > 0
          if $scope.remainingCount is 1
            logger.log('Almost there! Only ' + $scope.remainingCount + ' order left')
          else
            logger.log('Good job! Only ' + $scope.remainingCount + ' order left')
        else
          logger.logSuccess('Congrats! All done :)')

    $scope.clearCompleted = ->
      $scope.orders = orders = orders.filter( (val) ->
        return !val.completed
      )
      orderStorage.put(orders)

    $scope.markAll = (completed)->
      orders.forEach( (order) ->
        order.completed = completed
      )
      $scope.remainingCount = if completed then 0 else tasks.length
      orderStorage.put(orders)
      if completed
        logger.logSuccess('Congrats! All done :)')

    $scope.$watch('remainingCount == 0', (val) ->
      $scope.allChecked = val
    )

    $scope.$watch('remainingCount', (newVal, oldVal) ->
      $rootScope.$broadcast('orderRemaining:changed', newVal)
    )
])