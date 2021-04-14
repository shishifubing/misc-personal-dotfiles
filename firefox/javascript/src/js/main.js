function openPage() {
  browser.tabs.query({currentWindow: true, active: true})
    .then((tabs) => {
      let base = "https://supchat.taxi.yandex-team.ru/chatterbox-api/v1/tasks/"
      let uri = base + tabs[0].url.split('/')[4];
      browser.tabs.create({ url: uri });  
  })}

browser.browserAction.onClicked.addListener(openPage);
