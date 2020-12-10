# OpenWeatherAppService

Features:
  -Login with facebook. Stored access token in keychain. 
  -Integrate with openweathermap service.
  -Cache locally using UserDefaults.
  
Archetecture:
  -MVVM/ Service lives inside the view model and then updates the view.
  
Going beyond Prototype:
  -Setup a BAAS (FIREBASE) to store token and make the call for accesss token. 
  -Re-factor network service. Rite now it's setup for only one endpont. Scale this. 
  -Isolate the view's
  -Option of adding some navigation design.
