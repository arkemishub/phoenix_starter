defmodule PhoenixStarter.Mailer do
  use ArkeServer.Mailer

  def signin(conn,member,opts), do: {:ok,opts}
  def signup(conn,params,opts), do: {:ok,opts}
  def reset_password(conn,member,opts), do: {:ok,opts}
  # def send_email(opts) do
  #    email = get_email_struct(opts)
  #    deliver(email)
  #  end
end
