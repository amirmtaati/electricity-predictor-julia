module Evaluation
using Statistics

export calcMetrics

function calcMetrics(actual::Vector, predicted::Vector)
    mse = mean((actual - predicted).^2)
    rmse = sqrt(mse)
    mae = mean(abs.(actual - predicted))
    r2 = 1 - sum((actual - predicted).^2) / sum((actual .- mean(actual)).^2)
    return mse, rmse, mae, r2
end

end
