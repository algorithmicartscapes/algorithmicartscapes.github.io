// default filename (can be overwritten via input argument)
"twilight-granular.wav" => string FILENAME;
// get file name, if one specified as input x0argument
if( me.args() > 0 ) me.arg(0) => FILENAME;

// overall volume
1 => global float MAIN_VOLUME;
// grain duration base
50::ms => dur GRAIN_LENGTH;
50 => global float GRAIN_LENGTHF;
// factor relating grain duration to ramp up/down time
.5 => global float GRAIN_RAMP_FACTOR;
// playback rate
1 => global float GRAIN_PLAY_RATE;
// grain position (0 start; 1 end)
0 => global float GRAIN_POSITION;
// grain position goal (for interp)
0 => global float GRAIN_POSITION_GOAL;
// grain position randomization
.001 => global float GRAIN_POSITION_RANDOM;
// grain jitter (0 == periodic fire rate)
1 => global float GRAIN_FIRE_RANDOM;

0.05 => global float REVERB_MIX;

// max lisa voices
30 => int LISA_MAX_VOICES;
// load file into a LiSa (use one LiSa per sound)
load( me.dir()+FILENAME ) @=> LiSa @ lisa;

// patch it
PoleZero blocker => Gain g => NRev reverb => dac;
// feedback
g => Gain feedback => DelayL delay => g;


// set delay parameters
.75::second => delay.max => delay.delay;
// set feedback
.5 => feedback.gain;
// set effects mix
.75 => delay.gain;
// connect
lisa.chan(0) => blocker;

// reverb mix
REVERB_MIX => reverb.mix;
// pole location to block DC and ultra low frequencies
.99 => blocker.blockZero;

spork~interp( .025, 5::ms );
spork~gainMain();

function gainMain(){
    while(true){
        MAIN_VOLUME => reverb.gain;
        samp => now;
    }
}


// main loop
while( true )
{
    GRAIN_LENGTHF::ms => GRAIN_LENGTH;
    // fire a grain
    fireGrain();
    // amount here naturally controls amount of overlap between grains
    GRAIN_LENGTH / 8 + Math.random2f(0,GRAIN_FIRE_RANDOM)::ms => now;
}

// fire!
fun void fireGrain()
{
    // grain length
    GRAIN_LENGTH => dur grainLen;
    // ramp time
    GRAIN_LENGTH * GRAIN_RAMP_FACTOR => dur rampTime;
    // play pos
    GRAIN_POSITION + Math.random2f(0,GRAIN_POSITION_RANDOM) => float pos;
    // a grain
    if( lisa != null && pos >= 0 )
        spork ~ grain( lisa, pos * lisa.duration(), grainLen, rampTime, rampTime, 
        GRAIN_PLAY_RATE );
}

// interp
fun void interp( float slew, dur RATE )
{
    while( true )
    {
        // interp grain position
        (GRAIN_POSITION_GOAL - GRAIN_POSITION)*slew + GRAIN_POSITION => GRAIN_POSITION;
        // interp rate
        RATE => now;
    }
}

// grain sporkee
fun void grain( LiSa @ lisa, dur pos, dur grainLen, dur rampUp, dur rampDown, float rate )
{
    // get a voice to use
    lisa.getVoice() => int voice;

    // if available
    if( voice > -1 )
    {
        // set rate
        lisa.rate( voice, rate );
        // set playhead
        lisa.playPos( voice, pos );
        // ramp up
        lisa.rampUp( voice, rampUp );
        // wait
        (grainLen - rampUp) => now;
        // ramp down
        lisa.rampDown( voice, rampDown );
        // wait
        rampDown => now;
    }
}

// load file into a LiSa
fun LiSa load( string filename )
{
    // sound buffer
    SndBuf buffy;
    // load it
    filename => buffy.read;
    
    // new LiSa
    LiSa lisa;
    // set duration
    buffy.samples()::samp => lisa.duration;
    
    // transfer values from SndBuf to LiSa
    for( 0 => int i; i < buffy.samples(); i++ )
    {
        // args are sample value and sample index
        // (dur must be integral in samples)
        lisa.valueAt( buffy.valueAt(i), i::samp );        
    }
    
    // set LiSa parameters
    lisa.play( false );
    lisa.loop( false );
    lisa.maxVoices( LISA_MAX_VOICES );
    
    return lisa;
}