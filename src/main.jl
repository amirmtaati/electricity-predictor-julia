using Pkg
Pkg.add(["DataFrames", "CSV", "Dates", "Statistics", "Plots", "GLM"])

using DataFrames, CSV, Dates, Statistics, Plots, GLM

df = CSV.read("/home/amirmhmd/code/electricity-predictor-julia/data/PJME_hourly.csv", DataFrame)

println("Shape of data: ", size(df))
println("Column's names: ", names(df))
println(first(df, 10))
println(describe(df))

plot(df.Datetime, df.PJME_MW,
     title="Electricity Consumption",
     xlabel="Date",
     ylabel="Consumption (MW)",
     linewidth= 0.5,
     size=(800, 400))

format = dateformat"yyyy-mm-dd HH:MM:SS"
dt = DateTime.(df.Datetime, format)

df.hour = hour.(dt)
df.dayOfTheWeek = dayofweek.(dt)
df.month = month.(dt)
df.isWeekend = df.dayOfTheWeek .>= 6

sort!(df, :Datetime)
