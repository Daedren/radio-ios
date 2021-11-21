//import Foundation
//import FreeStreamer
//import Accelerate
//
//class PCMHandler: NSObject, FSPCMAudioStreamDelegate {
//    
//    var magnitudes = [Float]()
//    
//    func audioStream(_ audioStream: FSAudioStream!, samplesAvailable samples: UnsafeMutablePointer<AudioBufferList>!, frames: UInt32, description: AudioStreamPacketDescription) {
//        let frameCount = frames
//        let log2n = UInt(round(log2(Double(frameCount))))
//        let bufferSizePOT = Int(1 << log2n)
//        let inputCount = bufferSizePOT / 2
//        let fftSetup = vDSP_create_fftsetup(log2n, Int32(kFFTRadix2))
//        
//        var realp = [Float](repeating: 0, count: inputCount)
//        var imagp = [Float](repeating: 0, count: inputCount)
//        var output = DSPSplitComplex(realp: &realp, imagp: &imagp)
//        
//        let windowSize = bufferSizePOT
//        var transferBuffer = [Float](repeating: 0, count: windowSize)
//        var window = [Float](repeating: 0, count: windowSize)
//        
//        // Hann windowing to reduce the frequency leakage
//        let tempp = UnsafePointer<Float>(samples.pointee.mBuffers.mData)
//        vDSP_hann_window(&window, vDSP_Length(windowSize), Int32(vDSP_HANN_NORM))
//        vDSP_vmul((tempp)!, 1, window,
//                  1, &transferBuffer, 1, vDSP_Length(windowSize))
//        
//        // Transforming the [Float] buffer into a UnsafePointer<Float> object for the vDSP_ctoz method
//        // And then pack the input into the complex buffer (output)
//        let temp = UnsafePointer<Float>(transferBuffer)
//        temp.withMemoryRebound(to: DSPComplex.self,
//                               capacity: transferBuffer.count) {
//                                vDSP_ctoz($0, 2, &output, 1, vDSP_Length(inputCount))
//        }
//        
//        // Perform the FFT
//        vDSP_fft_zrip(fftSetup!, &output, 1, log2n, FFTDirection(FFT_FORWARD))
//        
//        var magnitudes = [Float](repeating: 0.0, count: inputCount)
//        vDSP_zvmags(&output, 1, &magnitudes, 1, vDSP_Length(inputCount))
//        
//        // Normalising
//        var normalizedMagnitudes = [Float](repeating: 0.0, count: inputCount)
//        vDSP_vsmul(sqrtq(magnitudes), 1, [2.0 / Float(inputCount)],
//                   &normalizedMagnitudes, 1, vDSP_Length(inputCount))
//        
//        self.magnitudes = magnitudes
//        vDSP_destroy_fftsetup(fftSetup)
//    }
//    
//    func sqrtq(_ x: [Float]) -> [Float] {
//        var results = [Float](repeating: 0.0, count: x.count)
//        vvsqrtf(&results, x, [Int32(x.count)])
//        
//        return results
//    }
//}
