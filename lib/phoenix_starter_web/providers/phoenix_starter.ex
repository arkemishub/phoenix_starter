defmodule PhoenixStarter.Provider.MyProvider do
  use ArkeServer.OAuth.Core

  @private_oauth_key :arke_server_oauth

  @doc """
  Prepare the UserInfo struct. first_name,last_name and email are required but wach provider may identify them under different
    keys
  """
  def info(conn) do
    token_data = conn.private[@private_oauth_key]

    %UserInfo{
      first_name: token_data["first_name"],
      last_name: token_data["last_name"],
      email: token_data["email"]
    }
  end
  @doc """
  Get the oauth provider id from returned from the provider
  """
  def uid(conn) do
    conn.private[@private_oauth_key]["id"]
  end
  @doc """
  Clean the connection to contain only the final data
  """
  def handle_cleanup(conn), do: put_private(conn, @private_oauth_key, nil)

  @doc """
  Prepare the conn with all the data needed
  """
  def handle_request(%Plug.Conn{} = conn) do
    # if everything is fine then
    # put_private(conn, @private_oauth_key, body)
    # if there is an error
    #Plug.Conn.assign(
    #  conn,
    #  :arke_server_oauth_failure,
    #  Error.create(:auth, "invalid token")
    #)
   conn
  end

  def handle_request(conn) do
    {:error, msg} = Error.create(:auth, "token not found")

    Plug.Conn.assign(
      conn,
      :arke_server_oauth_failure,
      msg
    )
  end

end