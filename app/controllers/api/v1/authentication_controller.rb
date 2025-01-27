module Api
  module V1
    class AuthenticationController < ApplicationController
      class AuthenticationError < StandardError; end
      rescue_from ActionController::ParameterMissing, with: :parameter_missing
      rescue_from AuthenticationError, with: :handle_authenticated

      def create

        raise AuthenticationError unless user.authenticate(params.require(:password))
        token = AuthenticationTokenService.encode(user.id)

        render json: { token: token }, status: :created
      end

      private

      def user
        @user ||= User.find_by(username: params.require(:username))
      end

      def parameter_missing(e)
        render json: { error: e.message.split("\n").first }, status: :unprocessable_entity
      end

      def handle_authenticated
        head :unauthorized
      end

    end
  end
end
