module GlobalSign
  module DnsVerificationForIssue
    class Response < GlobalSign::Response
      module XPath
        Certificate_Info   = '//Response/URLVerificationForIssue/CertificateInfo'
        CA_Certificates    = '//Response/URLVerificationForIssue/Fulfillment/CACertificates'
        Server_Certificate = '//Response/URLVerificationForIssue/Fulfillment/ServerCertificate'
      end

      def response_header
        :OrderResponseHeader
      end

      def params
        @params ||= {
          certificate_info: {
            certificate_status: certificate_info.at('CertificateStatus').text,
            start_date:         certificate_info.at('StartDate').text,
            end_date:           certificate_info.at('EndDate').text,
            common_name:        certificate_info.at('CommonName').text,
            subject_name:       certificate_info.at('SubjectName').text,
          },
          fulfillment: {
            ca_certificates: ca_certificates_list,
            server_certificate: {
              x509_cert:  server_certificate.at('X509Cert').text,
              pkcs7_cert: server_certificate.at('PKCS7Cert').text,
            }
          }
        }
      end

      private

      def certificate_info
        @xml.xpath(XPath::Certificate_Info)
      end

      def ca_certificates_list
        @xml.xpath(XPath::CA_Certificates).children.map do |c|
          {
            ca_cert_type: c.at('CACertType').text,
            ca_cert:      c.at('CACert').text,
          }
        end
      end

      def server_certificate
        @xml.xpath(XPath::Server_Certificate)
      end
    end
  end
end
