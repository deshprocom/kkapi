module Services
  module Account
    class CertificationService
      include Serviceable

      ID_REGEX = /^[1-9]\d{7}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}$|^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$/
      REAL_NAME_REGEX = /^[A-z]+$|^[\u4E00-\u9FA5]+$/

      def initialize(user, user_params, certification = nil)
        @user = user
        @user_params = user_params
        @certification = certification
      end

      def call
        real_name = @user_params[:real_name].strip
        cert_no = @user_params[:cert_no].strip
        type = @user_params[:cert_type]
        raise_error 'real_name_format_error' unless real_name_valid?(real_name)
        raise_error 'cert_no_format_error' unless cert_no_valid?(type, cert_no)
        @certification.blank? ? create_certification : update_certification
      end

      private

      def create_certification
        # 检查该用户是否提交过证件号的实名信息
        raise_error 'cert_no_already_exists' if cert_no_exists?
        common_new_certification
      end

      def update_certification
        # 审核通过的不可修改
        raise_error 'cert_cannot_update' if @certification.status.eql?('passed')
        # 非同一证件类型不可修改
        raise_error 'cert_cannot_update' unless @certification.cert_type.eql?(@user_params[:cert_type])
        common_new_certification
      end

      def common_new_certification
        @certification ||= UserExtra.new
        if @user_params[:image].present?
          @certification.image = @user_params[:image]
          raise_error 'file_format_error' if @certification.image.blank? || @certification.image.path.blank?
        end
        raise_error 'file_upload_error' unless @certification.save

        @certification.assign_attributes(user_id: @user.id,
                                         real_name: @user_params[:real_name],
                                         cert_no: @user_params[:cert_no],
                                         cert_type: @user_params[:cert_type],
                                         status: 'pending')
        @certification.save!
        ApiResult.success_with_data(user_extra: @certification)
      end

      def real_name_valid?(real_name)
        real_name =~ REAL_NAME_REGEX
      end

      def cert_no_valid?(type, cert_no)
        send "#{type}_valid?", cert_no
      end

      def chinese_id_valid?(chinese_id)
        chinese_id =~ ID_REGEX
      end

      def passport_id_valid?(_passport_id)
        true
      end

      def cert_no_exists?
        @user.user_extras.where(cert_no: @user_params[:cert_no]).exists?
      end
    end
  end
end
