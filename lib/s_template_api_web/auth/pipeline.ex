defmodule STemplateAPIWeb.Auth.Pipeline do
  @moduledoc """
  The Auth pipeline.

  This pipeline is used to authenticate the organization creating a JWT token with the payload.

  ## Header

  {
    "alg": "HS512",
    "typ": "JWT"
  }

  ## Payload
  {
    "aud": "s_template_api", Audience
    "exp": 1682456592, Expiration Time
    "iat": 1679864592, Issued At
    "iss": "s_template_api", Issuer
    "jti": "d0ef5d60-539f-47c8-addf-1fe8b9d74955", JWT ID
    "nbf": 1679864591, Not Before
    "sub": "04af6966-46f1-461f-90fe-15c35d2a59df", Subject
    "typ": "access" Type
  }
  """
  use Guardian.Plug.Pipeline,
    otp_app: :s_template_api,
    module: STemplateAPIWeb.Auth.Guardian,
    error_handler: STemplateAPIWeb.Auth.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true
end
