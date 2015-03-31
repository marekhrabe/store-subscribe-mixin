module.exports = (stores, getStateFromStores) ->
  unless stores?.length
    throw new TypeError 'You must provide an array of Stores to StoreSubscribeMixin'

  onChange = ->
    if typeof getStateFromStores is 'function'
      @setState(getStateFromStores()) if @isMounted()
    else if typeof @storesDidUpdate is 'function'
      @storesDidUpdate() if @isMounted()
    else
      throw new Error 'You need to implement `storesDidUpdate` method on component or pass getStateFromStores function as a second argument of StoreSubscribeMixin'

  mixin = {
    componentDidMount: ->
      store.addChangeListener(onChange.bind(this)) for store in stores
      return null

    componentWillUnmount: ->
      store.removeChangeListener(onChange.bind(this)) for store in stores
      return null
  }

  if typeof getStateFromStores is 'function'
    mixin.getInitialState = ->
      return getStateFromStores()

  return mixin

module.exports.componentDidMount = ->
  console.error 'StoreSubscribeMixin needs to be called with an array of Stores. Like this: `React.createClass({ mixins: StoreSubscribeMixin([Store1, Store2]) })`'
