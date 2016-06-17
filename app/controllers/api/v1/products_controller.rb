class Api::V1::ProductsController < Api::V1::BaseController
    before_action :set_uuid, only: [:update]

    def index
        render json: Product.all.as_json(only: [:uuid]), status: 200
    end

    def update
        puts '--------- Params ---------'
        puts params

        if product = Product.where(uuid: @uuid).first
            # We have a product with this uuid
            if product.update(product_params)
                render json: product.to_json, status: 201
            else
                render json: { message: 'failure updating', params: product_params }, status: 500
            end
        else
            # Let's create a new product
            product = Product.new(product_params)
            if product.save
                render json: product.to_json, status: 201
            else
                render json: { message: 'failure creating', product: product, params: product_params }, status: 500
            end
        end
    end

    private

    def set_uuid
        unless params[:id].nil?
            @uuid = params[:id]
            params[:uuid] = @uuid
        end
        params.delete(:controller)
        params.delete(:id)
        params.delete(:action)
    end

    def product_params
        params.permit(:name, :price, :stock, :description, :family, :promotion, :image, :uuid)
    end

end
