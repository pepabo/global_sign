module GlobalSign
  module CsrDecoder
    class Response < GlobalSign::Response
      module XPath
        CSRData            = '//Response/CSRData'
        CertificatePreview = '//Response/CertificatePreview'
      end

      def response_header
        :QueryResponseHeader
      end

      def params
        @params ||= {
          csr_data:            detail(@xml.xpath(XPath::CSRData)),
          certificate_preview: detail(@xml.xpath(XPath::CertificatePreview))
        }
      end

      private

      def detail(data)
        {
          common_name:       data.at('CommonName').try(:text)   || '',
          organization:      data.at('Organization').try(:text) || '',
          organization_unit: data.at('Organization').try(:text) || '',
          locality:          data.at('Locality').try(:text)     || '',
          state:             data.at('State').try(:text)        || '',
          country:           data.at('Country').try(:text)      || '',
          email_address:     data.at('EmailAddress').try(:text) || '',
          key_length:        data.at('KeyLength').try(:text)    || ''
        }
      end
    end
  end
end
