command: 'who'

refreshFrequency:  1000

style: """
  top: 30px
  left: 40px
  color: #fff
  font-family: Helvetica Neue
  font-size: 12px

  .none-title
    display:none
  .no-users .none-title
    display: block
  .no-users .title
    display:none
"""

render: (output) -> """
  <div class='container'>
    <h4 class='none-title'>No remote logins</h4>
    <h4 class='title'>Current remote logins:</h4>
    <div class="users"></div>
  </div>
"""

update: (output, domEl) ->
  ipRegex = /\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/;
  dom = $(domEl)
  container = $('.container')
  lines = output.split('\n')
  mapped = lines.map (line) =>
    els = line.split(' ').filter (n) =>
      return n != ''
    if els.length
      id = els.join('').split('').reduce ((a, b) ->
        a = (a << 5) - a + b.charCodeAt(0)
        a & a
        ), 0
      uname = els.splice(0, 1)[0]
      method = els.splice(0, 1)[0]
      loginDate = els.splice(0, 3).join(' ')
      if els.length > 0 
        remoteAddress = JSON.stringify(els).toString().match(ipRegex)[0]
      else 
        remoteAddress = false
      return {
        id: Math.abs(id),
        uname: uname,
        method: method,
        loginDate: loginDate,
        remoteAddress: remoteAddress
      }
    else
      false
  .filter (item) =>
     item.id && item.remoteAddress
  if mapped.length < 1
    container.addClass('no-users')
    container.find('.users')[0].innerHTML = ''
  else
   container.removeClass('no-users')
  for line in mapped
    if $('#'+line.id).length < 1
      el = $('<h4 id="'+line.id+'" class="entry">'+line.uname+' | '+line.method+' | '+line.loginDate+' | '+line.remoteAddress+'</h4>')
      el.attr('id', line.id)
      dom.find('.users').append el


