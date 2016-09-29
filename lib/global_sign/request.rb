module GlobalSign
  class Request
    def to_xml
      GlobalSign::RequestXmlBuilder.build_xml(
        action: action,
        params: auth_token_params.merge(params)
      )
    end

    def auth_token_params
      {
        OrderRequestHeader: {
          AuthToken: {
            UserName: GlobalSign.configuration.user_name,
            Password: GlobalSign.configuration.password,
          }
        }
      }
    end
  end
end
