public class Cq {
    SndBuf buf;

    .5::second => dur T;
    T - (now % T) => now;

    function void play(string sample, int notes[]){
            
        1.0/(notes.cap()-1) => float d;
        sample + ".wav" => buf.read;
        buf => dac;
            
        while( true )
        {
            for(0 => int i; i  < (notes.cap()-1); i++){
                if(notes[i] == 1){
                    0 => buf.pos;
                    d::T => now;
                }
                if(notes[i] == 0){
                    d::T => now;
                }
            }
        }
    }
}