let buttonStates = ['off', 'on', 'start', 'finish']

document.querySelectorAll('.wall-light').forEach(button => {
  button.addEventListener('click', event => {

    event.preventDefault();
    fetch(button.getAttribute('data-action'), { method: 'POST' })

    let index = Math.max(0, buttonStates.indexOf(button.getAttribute('data-state')))
    button.setAttribute('data-state', buttonStates[index + 1] || 'off');
  })
})

document.querySelectorAll('input.brightnessSlider').forEach(element => {
  element.addEventListener('change', (event) => {
    let form = document.querySelector('form.setBrightness')
    let formData = new FormData();
    formData.append('brightness', event.target.value);

    fetch(form.action, { method: 'POST', body: formData })
  })
})

document.querySelectorAll('form.newRoute').forEach(element => {
  element.addEventListener('submit', (event) => {
    let wallState = {}
    document.querySelectorAll('.wall-light').forEach(light => {
      state = light.getAttribute('data-state')
      if(state != 'off') {
        wallState[light.getAttribute('data-key')] = light.getAttribute('data-state')
      }
    })
    document.querySelector('.wall-state-input').value = JSON.stringify(wallState)
  })
})

document.querySelectorAll('form.deleteRoute').forEach(element => {
  element.addEventListener('submit', (event) => {
    if(!confirm("Sure you want to delete this route?")) {
      event.preventDefault()
    }
  })
})


document.querySelectorAll('.load-route-link').forEach(link => {
  link.text = link.getAttribute('data-text')

  link.addEventListener('click', (event) => {
    event.preventDefault();

    document.querySelectorAll('.load-route-link').forEach(otherLink => {
      otherLink.text = link.getAttribute('data-text')
    })

    let loadingSpan = document.createElement('span');
    loadingSpan.className = 'spinner-border spinner-border-sm mx-2';
    link.text = ''
    link.prepend(loadingSpan);
    fetch(link.getAttribute('href')).then(() => {
      link.removeChild(loadingSpan);
      link.text = link.getAttribute('data-loaded-text');
    })
  })
})
