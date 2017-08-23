module GlobalSign
  module DVApproverList
    class Response < GlobalSign::Response
      module XPath
        ORDER_ID = '//Response/OrderID'.freeze
        APPROVERS = '//Response/Approvers'.freeze
        SEARCH_ORDER_DETAIL = '//Approvers/SearchOrderDetail'.freeze
      end

      def response_header
        :QueryResponseHeader
      end

      def params
        @params ||= {
          order_id: @xml.xpath(XPath::ORDER_ID).text,
          approvers: approvers_list
        }
      end

      private

      def approvers_list
        @approvers ||= @xml.xpath(XPath::SEARCH_ORDER_DETAIL).map do |approver|
          {
            type: approver.xpath('ApproverType').text,
            email: approver.xpath('ApproverEmail').text
          }
        end
      end
    end
  end
end
