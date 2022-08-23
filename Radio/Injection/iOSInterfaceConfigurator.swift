import Foundation
import Radio_cross
import Radio_domain
import Radio_data
import Radio_cross
import Radio_interfaces

class iOSInterfaceConfigurator {
    init() {
        
        InjectSettings.shared.register(HTMLParser.self) {
            return DataHTMLParser()
        }
        
        InjectSettings.shared.register(MusicGateway.self) {
            let client = AVClient()
            return MusicRepository(client: client)
        }
        
//        InjectSettings.shared.register(AVGateway.self) {
//            let client = FSClient(logger: InjectSettings.shared.resolve(LoggerWrapper.self)!)
//            return AVGatewayImp(logger: InjectSettings.shared.resolve(LoggerWrapper.self)!, client: client)
//        }
        
        InjectSettings.shared.register(MuteBackgroundTask.self) {
            return MuteBackgroundTask(muteUseCase: InjectSettings.shared.resolve(StopRadioUseCase.self)!
            )
        }
        
        InjectSettings.shared.register(TaskManager.self) {
            let handlers: [ScheduledTask] = [
                InjectSettings.shared.resolve(MuteBackgroundTask.self)!
            ]
            return TimerManagerImpl(handlers: handlers)
//            return BackgroundManagerImpl(handlers: handlers)
        }
        
        InjectSettings.shared.register(ToggleSleepTimerUseCase.self) {
            return ToggleSleepTimerInteractor(sleepGateway: InjectSettings.shared.resolve(SleepGateway.self)!)
        }
        
        InjectSettings.shared.register(SleepGateway.self) {
            return SleepRepository(backgroundService: InjectSettings.shared.resolve(TaskManager.self)!)
        }
    }
}
