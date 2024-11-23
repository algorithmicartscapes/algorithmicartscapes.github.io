 Word2Vec model;

        // loading any default here
        me.dir() + "2dimentions.txt" => string filepath;
        <<< "loading 2D model:", filepath, "..." >>>;
        model.load( filepath );
        print( model ) => global int MODELLOADED;

        // print info about a loaded Word2Vec model
        fun int print( Word2Vec model )
        {
            // print info
            <<< "dictionary size:", model.size() >>>;
            <<< "embedding dimensions:", model.dim() >>>;
            <<< "using KDTree for search:", model.useKDTree() ? "YES" : "NO" >>>;        
            // get bounds
            float mins[0], maxs[0];
            model.minMax( mins, maxs );
            for( int i; i < model.dim(); i++ )
            { cherr <= "dimension " <= i <= " range: [" <= mins[i] <= ", "
                    <= maxs[i] <= "]" <= IO.newline(); }

            return true;
        }

        float mins[0], maxs[0];
        // get bounds for each dimension
        model.minMax( mins, maxs );

        string words[20];
        global string w0;
        global string w1;
        global string w2;
        global string w3;
        global string w4;
        global string w5;
        global string w6;
        global string w7;
        global string w8;
        global string w9;
        global string w10;
        global string w11;
        global string w12;
        global string w13;
        global string w14;
        global string w15;
        global string w16;
        global string w17;
        global string w18;
        global string w19;

        global string keyword;

        global Event newScore;

        ["smooth","extra","grayscale","gradient","pastel","vibes","celestial","sea"] @=> string references[];

        getWords("move");

        while(true){
          newScore => now;
          //getWords(references[Math.random2(0,references.size()-1)]);
          getWords(keyword);
        }

        fun void getWords(string ref){
  
           model.getSimilar(ref, words.size(), words);

            words[0] => w0;
            words[1] => w1;
            words[2] => w2;
            words[3] => w3;
            words[4] => w4;
            words[5] => w5;
            words[6] => w6;
            words[7] => w7;
            words[8] => w8;
            words[9] => w9;
            words[10] => w10;
            words[11] => w11;
            words[12] => w12;
            words[13] => w13;
            words[14] => w14;
            words[15] => w15;
            words[16] => w16;
            words[17] => w17;
            words[18] => w18;
            words[19] => w19;
        }

        //------------------------------------------------------------------------------
    // word2vec helper
    //------------------------------------------------------------------------------
    class W2V
    {
        fun static void copy( float to[], float from[] )
        {
            to.size(from.size());
            // add into element
            for( int i; i < to.size(); i++ ) from[i] => to[i];
        }

        fun static float[] dup( float from[] )
        {
            float to[from.size()];
            // add into element
            for( int i; i < to.size(); i++ ) from[i] => to[i];
            // return
            return to;
        }

        // result stored in x
        fun static void add( float x[], float y[] )
        {
            // smaller of the two
            x.size() < y.size() ? x.size() : y.size() => int size;
            // add into element
            for( int i; i < size; i++ ) y[i] +=> x[i];
        }

        // result stored in x
        fun static void minus( float x[], float y[] )
        {
            // smaller of the two
            x.size() < y.size() ? x.size() : y.size() => int size;
            // add into element
            for( int i; i < size; i++ ) y[i] -=> x[i];
        }

        fun static void scale( float x[], float scalar )
        {
            // scale
            for( int i; i < x.size(); i++ ) scalar *=> x[i];
        }

        fun static void scale( float result[], float x[], float scalar )
        {
            // scale
            for( int i; i < x.size(); i++ ) scalar * x[i] => result[i];
        }

        fun static string[] eval( Word2Vec @ w, string expr, int k )
        {
            // init @
            int pos;
            1.0 => float multiplier;
            string word;
            float wordVector[w.dim()];
            float exprVector[w.dim()];

            // compute
            while( true )
            {
                expr.find(" ") => pos;
                if( pos == -1 )
                {
                    w.getVector(expr, wordVector);
                    for( 0 => int i; i < w.dim(); i++ )
                    {
                        wordVector[i] * multiplier +=> exprVector[i];
                    }
                    break;
                }
                else
                {
                    expr.substring(0, pos) => word;
                    w.getVector(word, wordVector);
                    for( 0 => int i; i < w.dim(); i++ )
                    {
                        wordVector[i] * multiplier +=> exprVector[i];
                    }
                    expr.substring(pos + 1) => expr;
                    if( expr.charAt(0) == '+' )
                    {
                        1.0 => multiplier;
                        expr.substring(2) => expr;
                    }
                    else
                    {
                        -1.0 => multiplier;
                        expr.substring(2) => expr;
                    }
                }
            }

            // return
            string results[k];
            w.getSimilar( exprVector, k, results );

            return results;
        }

        // logical analogy: A to B is as C is to [what this function returns]
        fun static string[] analogy( Word2Vec @ w, string A, string B, string C, int k )
        {
            // the vector sum
            B + " - " + A + " + " + C => string v;
            return eval( w, v, k );
        }
    }