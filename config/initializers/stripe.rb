Rails.configuration.stripe = {
  publishable_key: 'pk_test_51GxSBrEk0TwOwGNGkzdp7XFqEnMqYDzZknQcEbA5K8ToV3VbPF6xqRgv5QsGIwEqO35ftnteu5d2D6u2gGHVQgPG00wi1iT54b',
  secret_key: 'sk_test_51GxSBrEk0TwOwGNG9Wxn3DgKstcmy6xI7rpdCfy6JKmfjGQkHwaGEtMBOI52aSfjSfa32QZL1W5YPTDzMET728kP00J7HXtNVN'
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]