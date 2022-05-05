# prepare climate data for ABIMO 1991-2019

potential_evaporation_berlin_output <- kwb.dwd:::load_potential_evaporation_berlin()

###get potential evaporation data-----------------------------------

evaporation_matrices <- potential_evaporation_berlin_output
berlin_evap_monthly <- potential_evaporation_berlin_output$mean

###get precipitation data---------------------------------------------
# Be careful! This process might take at least 15 minutes
precipitation_berlin_output <- kwb.dwd:::load_precipitation_berlin()

###assemble ABIMO climate data----------------------------------------

years <- unique(potential_evaporation_berlin_output$year)

# Defining the summer months -----!!!edit months!!!------
sum_months <- c(4:9)

# Define lists
rain_yr <- c()
pot_ev_yr <- c()
rain_sum <- c()
pot_ev_sum <- c()

for (i in (1:length(years)))
{
  year <- years[i]
  # Get the indices for potential evaporation and precipitation
  pot_ev_indices_yr <- which(potential_evaporation_berlin_output$year == year)
  pot_ev_indices_sum <- which(potential_evaporation_berlin_output$year == year &
                              potential_evaporation_berlin_output$month %in% sum_months)

  rain_indices_yr <- which(precipitation_berlin_output$year == year)
  rain_indices_sum <- which(precipitation_berlin_output$year == year &
                            precipitation_berlin_output$month %in% sum_months)


  rain_yr[i] <- sum(precipitation_berlin_output$mean[rain_indices_yr])
  pot_ev_yr[i] <- sum(potential_evaporation_berlin_output$mean[pot_ev_indices_yr])
  rain_sum[i] <- sum(precipitation_berlin_output$mean[rain_indices_sum])
  pot_ev_sum[i] <- sum(potential_evaporation_berlin_output$mean[pot_ev_indices_sum])
}


abimo_climate_data <- data.frame(year = years,
                                 rain_yr = rain_yr,
                                 rain_sum = rain_sum,
                                 pot_ev_yr = pot_ev_yr,
                                 pot_ev_sum = pot_ev_sum)


write.csv(abimo_climate_data, file = 'C:/Users/lgueri/kwb_workspace/projects/amarex/ABIMO/daten_abimo_paper/DWD/Regen/ABIMO_climate_data_new.csv')


########################### PLOT ABIMO_CLIMATE_DATA ############################
library(ggplot2)
#theme_set(theme_classic())


ggplot(abimo_climate_data, aes(x=year, y=rain_yr)) +
  geom_bar(aes(y=rain_yr, fill='rain year'), position='dodge', stat='identity') +
  geom_bar(aes(y=rain_sum, fill='rain apr-sep'), position='dodge', stat='identity') +
  theme(axis.text.x = element_text(angle=0, vjust=0.6)) +
  scale_x_continuous(breaks = seq(1991, 2021, 2)) +
  geom_text(aes(label=round(rain_yr,1)), vjust=-0.3, size=2.5) +
  labs(title="Histogram on Annual and Summer Rainfall in Berlin", x='year', y='rainfall [mm]')


########################### ONLY EVALUTATION PURPOSES ##########################
# Check, if old and new computation of precipitation and pot evaporation are in similar range
new_csv <- read.csv(file = 'C:/Users/lgueri/kwb_workspace/projects/amarex/ABIMO/daten_abimo_paper/DWD/Regen/ABIMO_climate_data_new.csv')
old_csv <- read.csv(file = 'C:/Users/lgueri/kwb_workspace/projects/amarex/ABIMO/daten_abimo_paper/DWD/Regen/ABIMO_climate_data.csv')
library(ggplot2)
library(Metrics)

df_rain <- data.frame(rain_yr_new_calc = new_csv$rain_yr[1:29], rain_yr_old_calc = old_csv$rain_yr)
ggplot(df_rain, aes(x=rain_yr_new_calc, y=rain_yr_old_calc)) +
  geom_point() +
  geom_abline(intercept = 0, slope = 1)# +
  #annotate("label", x = 500, y = 500, label = "avg rate")

df_pot_ev <- data.frame(pot_ev_yr_new_calc = new_csv$pot_ev_yr[1:29], pot_ev_yr_old_calc = old_csv$pot_ev_yr)
ggplot(df_pot_ev, aes(x=pot_ev_yr_new_calc, y=pot_ev_yr_old_calc)) +
  geom_point() +
  geom_abline(intercept = 0, slope = 1)


rain_yr_rmse <- round(rmse(df_rain$rain_yr_new_calc, df_rain$rain_yr_old_calc),4)
rain_yr_mape <- round(mape(df_rain$rain_yr_new_calc, df_rain$rain_yr_old_calc),4)

paste('RMSE between old and new calc. method for rain_yr:',rain_yr_rmse)
paste('MAPE between old and new calc. method for rain_yr:',rain_yr_mape, "%")


pot_ev_yr_rmse <- round(rmse(df_pot_ev$pot_ev_yr_new_calc, df_pot_ev$pot_ev_yr_old_calc),4)
pot_ev_yr_mape <- round(mape(df_pot_ev$pot_ev_yr_new_calc, df_pot_ev$pot_ev_yr_old_calc),4)

paste('RMSE between old and new calc. method for pot_ev_yr:',pot_ev_yr_rmse)
paste('MAPE between old and new calc. method for pot_ev_yr:',pot_ev_yr_mape,"%")
