module GlobalSign
  module GetOrderByOrderId
    class Response < GlobalSign::Response
      module XPath
      end

      def params
        @params ||= {}
      end
    end
  end
end
