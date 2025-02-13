﻿using System.Collections.ObjectModel;

namespace Roberta.Io
{
    public interface IRobertaClient
    {
        Task Echo(string message);
        Task Iam(string screenName);

        // Drivers
        Task AddDriver(string userName);
        Task DriversUpdated(ObservableCollection<Driver> drivers);
        Task SetDriver(string userName);
        Task StartDriving(string connectionId);
        Task StopDriving();
        Task RemoveDriver(string userName);

        // Driving
        Task SetCommandPriority(CommandPriority commandPriority);
        Task SetXY(decimal x, decimal y);
        Task SetPowerScale(decimal powerScale);

        // Roberta
        Task GpsMixerStateUpdated(GpsMixerState gpsMixerState);
        Task GpsStateUpdated(GpsState gpsState);
        Task RoboteqStateUpdated(RoboteqState roboteqState);
        Task RxStateUpdated(RxState rxState);
        Task ThumbstickStateUpdated(ThumbstickState thumbstickState);
    }
}
