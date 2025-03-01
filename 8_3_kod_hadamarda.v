`timescale 1ns/1ns
module hadamard_enkoder
(
    input [2:0] wektor_wejsciowy,     
    output [7:0] slowo_kodowe_indeks  
);

    wire [23:0] generator = 
    { 
        3'b000,
        3'b001,
        3'b010,
        3'b011,
        3'b100,
        3'b101,
        3'b110,
        3'b111
    };

    assign slowo_kodowe_indeks[0] = (generator[0] & wektor_wejsciowy[2]) ^ (generator[1] & wektor_wejsciowy[1]) ^ (generator[2] & wektor_wejsciowy[0]);
    assign slowo_kodowe_indeks[1] = (generator[3] & wektor_wejsciowy[2]) ^ (generator[4] & wektor_wejsciowy[1]) ^ (generator[5] & wektor_wejsciowy[0]);
    assign slowo_kodowe_indeks[2] = (generator[6] & wektor_wejsciowy[2]) ^ (generator[7] & wektor_wejsciowy[1]) ^ (generator[8] & wektor_wejsciowy[0]);
    assign slowo_kodowe_indeks[3] = (generator[9] & wektor_wejsciowy[2]) ^ (generator[10] & wektor_wejsciowy[1]) ^ (generator[11] & wektor_wejsciowy[0]);
    assign slowo_kodowe_indeks[4] = (generator[12] & wektor_wejsciowy[2]) ^ (generator[13] & wektor_wejsciowy[1]) ^ (generator[14] & wektor_wejsciowy[0]);
    assign slowo_kodowe_indeks[5] = (generator[15] & wektor_wejsciowy[2]) ^ (generator[16] & wektor_wejsciowy[1]) ^ (generator[17] & wektor_wejsciowy[0]);
    assign slowo_kodowe_indeks[6] = (generator[18] & wektor_wejsciowy[2]) ^ (generator[19] & wektor_wejsciowy[1]) ^ (generator[20] & wektor_wejsciowy[0]);
    assign slowo_kodowe_indeks[7] = (generator[21] & wektor_wejsciowy[2]) ^ (generator[22] & wektor_wejsciowy[1]) ^ (generator[23] & wektor_wejsciowy[0]);
endmodule


module hadamard_detekcja_korekcja_dekoder 
(
    input [7:0] wek,
    output reg [7:0] slowo_kodowe_indeks2,
    output reg [2:0] wektor_wyjsciowy
);

    wire [63:0] gen = 
    {
        8'b00000000,
        8'b00001111,
        8'b00110011,
        8'b00111100,
        8'b01010101,
        8'b01011010,
        8'b01100110,
        8'b01101001
    };
    
    integer i;
    reg [3:0] min_hamming_dist;
    reg [3:0] hamming_dist;
    reg [2:0] odwrocone;
    
    always @(*) begin
        min_hamming_dist = 8;
        odwrocone = 3'b000;
        slowo_kodowe_indeks2 = 8'b00000000;
        
        for (i = 0; i < 8; i = i + 1) begin
            hamming_dist = (wek[0] ^ gen[i*8+0]) +
                           (wek[1] ^ gen[i*8+1]) +
                           (wek[2] ^ gen[i*8+2]) +
                           (wek[3] ^ gen[i*8+3]) +
                           (wek[4] ^ gen[i*8+4]) +
                           (wek[5] ^ gen[i*8+5]) +
                           (wek[6] ^ gen[i*8+6]) +
                           (wek[7] ^ gen[i*8+7]);
            
            if (hamming_dist < min_hamming_dist) begin
                min_hamming_dist = hamming_dist;
                odwrocone = i[2:0];
                slowo_kodowe_indeks2 = gen[i*8 +: 8];
            end
        end
        
        wektor_wyjsciowy = ~odwrocone;
    end
endmodule




module hadamard_glowne;
    reg [2:0] wektor_wejsciowy;          
    wire [7:0] slowo_kodowe_indeks;    
    reg [7:0] wek;
    wire [7:0] slowo_kodowe_indeks2;
    wire [2:0] wektor_wyjsciowy;
    integer i;

    hadamard_enkoder hdmrd1 
    (
        .wektor_wejsciowy(wektor_wejsciowy),
        .slowo_kodowe_indeks(slowo_kodowe_indeks)
    );

    hadamard_detekcja_korekcja_dekoder  hdmrd
    (
        .wek(wek),
        .slowo_kodowe_indeks2(slowo_kodowe_indeks2),
        .wektor_wyjsciowy(wektor_wyjsciowy)
    );


    initial begin
        $display("\nKod hadamarda typu 8,3");
        for (i = 0; i <= 7; i = i + 1) begin
            wektor_wejsciowy = i;
            #25;
           wek = slowo_kodowe_indeks ^ 8'b00000001;
           #25;
            $display("Bity informacyjne: %b Zakodowane slowo kodowe: %b  Slowo kodowe z bledem: %b  Naprawione slowo kodowe: %b,  Zdekodowana wiadomosc: %b  ", wektor_wejsciowy, slowo_kodowe_indeks, wek, slowo_kodowe_indeks2, wektor_wyjsciowy);
        end
        $dumpvars(1, hadamard_glowne); 
        $finish;
    end
    
    initial begin
        $dumpfile( "wyniki_hadamard.vcd");
        $dumpvars(1, wektor_wejsciowy, slowo_kodowe_indeks, wek, slowo_kodowe_indeks2, wektor_wyjsciowy );
    end
endmodule
