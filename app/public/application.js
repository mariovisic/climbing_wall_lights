let buttonStates = ['off', 'on', 'start', 'finish']

document.querySelectorAll('.wall-light').forEach(button => {
  button.addEventListener('click', event => {

    event.preventDefault();
    fetch(button.getAttribute('data-action'), { method: 'POST' })

    let index = Math.max(0, buttonStates.indexOf(button.getAttribute('data-state')))
    button.setAttribute('data-state', buttonStates[index + 1]);
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
  addEventListener('submit', (event) => {
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
