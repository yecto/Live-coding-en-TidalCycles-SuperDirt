// Live Coding a través de TidalCycles + SuperDirt
// por si acá, como que a las de acá.
s.quit;
Server.killAll;
s.options.sampleRate = 48000;
s.boot;

// las siguientes líneas
// nos ayudan visualizar el sonido.
FreqScope.new(500, 50 , 0, server: s);
s.meter;
s.scope;
s.makeGui; // para ver al Server y/o grabar

/*
El código de SuperDirt fue creado por Alex McLean y Julian Rohrhuber
y puedes consultarlo en "https://github.com/musikinformatik/SuperDirt"
Para fines del Taller decidí crear un archivo agregando algunas líneas
de código al principio, que pueden resultar útiles.
*/

//ésta es la primer línea que ejecutarémos en SuperCollider
include("SuperDirt");

// Después ejecutamos todo éste código, el cual arranca
// SuperDirt, carga nuestros sampleos y prende el Server.
(
// configure the sound server: here you could add hardware specific options
// see http://doc.sccode.org/Classes/ServerOptions.html
s.options.numBuffers = 12024 * 16; // increase this if you need to load more samples
s.options.memSize = 12192 * 16; // increase this if you get "alloc failed" messages
s.options.maxNodes = 12024 * 32; // increase this if you are getting drop outs and the message "too many nodes"
s.options.numOutputBusChannels = 2; // set this to your hardware output channel size, if necessary
s.options.numInputBusChannels = 2; // set this to your hardware output channel size, if necessary
// boot the server and start SuperDirt
s.waitForBoot {
    ~dirt = SuperDirt(2, s); // two output channels, increase if you want to pan across more channels
    //~dirt.loadSoundFiles;
	~dirt.loadSoundFiles("/Users/velasco_/Dirt/samples_perc"); // éste folder es donde tenemos nuestros sampleos ( .
	// load samples (path can be passed in. You can drag and drop folders into the editor.)
	s.sync; // wait for samples to be read
    //~dirt.start(57120, [0, 0]);   // start listening on port 57120, create two busses each sending audio to channel 0
    ~dirt.start(57120, 0 ! 8);
}
)

// ésto es para TidalCycles.
/*
(cps, getNow) <- bpsUtils
(d1, t1) <- superDirtSetters getNow
(d2, t2) <- superDirtSetters getNow
*/

// para grabar //
// recording //
s.prepareForRecord;
s.record;
// stopRecording //
r.stop;
s.stopRecording;

MethodOverride.printAll

