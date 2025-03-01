`timescale  1ns/1ns
module hamming_enkoder
(
    input [32:1] di,   // 32 bity informacyjne na wejściu.
    input typ_parz,     // typ parzystości: 0 parzystośc, 1 nieparzystość.
    output [38:1] zakodowane,  // 38 bitów na wyjściu (32 bity informacyjne i 6 bitow parzystości)
    output p1, p2, p3, p4, p5, p6 
);
    // kalkulacja bitów parzystosci
    assign p1 = typ_parz ^ di[1] ^ di[2] ^ di[4] ^ di[5] ^ di[7] ^ di[9] ^ di[11] ^ di[12] ^ di[14] ^ di[16] ^
    di[18] ^ di[20] ^ di[22] ^ di[24] ^ di[26] ^ di[27] ^ di[29] ^ di[31];

    assign p2 = typ_parz ^ di[1] ^ di[3] ^ di[4] ^ di[6] ^ di[7] ^ di[10] ^ di[11] ^ di[13] ^ di[14] ^
    di[17] ^ di[18] ^ di[21] ^ di[22] ^ di[25] ^ di[26] ^ di[28] ^ di[29] ^ di[32];
    
    assign p3 = typ_parz ^ di[2] ^ di[3] ^ di[4] ^
    di[8] ^ di[9] ^ di[10] ^ di[11] ^
    di[15] ^ di[16] ^ di[17] ^ di[18] ^
    di[23] ^ di[24] ^ di[25] ^ di[26] ^
    di[30] ^ di[31] ^ di[32];

    assign p4 = typ_parz ^ di[5] ^ di[6] ^ di[7] ^ di[8] ^ di[9] ^ di[10] ^ di[11] ^ 
    di[19] ^ di[20] ^ di[21] ^ di[22] ^ di[23] ^ di[24] ^ di[25] ^ di[26];

    assign p5 = typ_parz ^ di[12] ^ di[13] ^ di[14] ^ di[15] ^ di[16] ^ di[17] ^ di[18] ^ di[19] ^ di[20] ^
    di[21] ^ di[22] ^ di[23] ^ di[24] ^ di[25] ^ di[26];
 
    assign p6 = typ_parz ^ di[27] ^ di[28] ^ di[29] ^ di[30] ^ di[31] ^ di[32];

    // umieszczenie bitów informacyjnych i bitów parzystości w ciągu (wygląd słowa kodowego po wyjściu z enkodera)
    // na indeksach potęg liczby 2 --> bity parzystości; na pozostałych indeksach --> bity informacyjne
    assign zakodowane = {di[32], di[31], di[30], di[29], di[28], di[27], p6, di[26], 
    di[25], di[24], di[23], di[22], di[21], di[20], di[19], di[18], di[17],
     di[16], di[15], di[14], di[13], di[12], p5, di[11], di[10], di[9], di[8],
      di[7], di[6], di[5], p4 ,di[4], di[3], di[2], p3, di[1], p2, p1};
endmodule

module hamming_detekcja_korekcja_dekoder 
(
    input [38:1] ci,   
    input typ_parzystosci,     
    output [38:1] data_out, 
    output reg blad,       
    output [6:1] indeks_bledu,  
    output s1, s2, s3, s4, s5, s6,
    output [32:1] zdekodowane
);
    // kalkulacja bitów syndromu
    assign s1 = typ_parzystosci ^ ci[1] ^ ci[3] ^ ci[5] ^ ci[7] ^ ci[9] ^ ci[11] ^ ci[13] ^ ci[15] ^
                ci[17] ^ ci[19] ^ ci[21] ^ ci[23] ^ ci[25] ^ ci[27] ^ ci[29] ^ ci[31] ^ ci[33] ^
                ci[35] ^ ci[37];

    assign s2 = typ_parzystosci ^ ci[2] ^ ci[3] ^ ci[6] ^ ci[7] ^ ci[10] ^ ci[11] ^ ci[14] ^
                ci[15] ^ ci[18] ^ ci[19] ^ ci[22] ^ ci[23] ^ ci[26] ^ ci[27] ^
                ci[30] ^ ci[31] ^ ci[34] ^ ci[35] ^ ci[38];

    assign s3 = typ_parzystosci ^ ci[4] ^ ci[5] ^ ci[6] ^ ci[7] ^ ci[12] ^ ci[13] ^ ci[14] ^ ci[15] ^
                ci[20] ^ ci[21] ^ ci[22] ^ ci[23] ^ ci[28] ^ ci[29] ^ ci[30] ^ ci[31] ^ ci[36] ^
                ci[37] ^ ci[38];

    assign s4 = typ_parzystosci ^ ci[8] ^ ci[9] ^ ci[10] ^ ci[11] ^ ci[12] ^ ci[13] ^ ci[14] ^
                ci[15] ^ ci[24] ^ ci[25] ^ ci[26] ^ ci[27] ^ ci[28] ^ ci[29] ^ ci[30] ^
                ci[31];

    assign s5 = typ_parzystosci ^ ci[16] ^ ci[17] ^ ci[18] ^ ci[19] ^ ci[20] ^ ci[21] ^ ci[22] ^
                ci[23] ^ ci[24] ^ ci[25] ^ ci[26] ^ ci[27] ^ ci[28] ^ ci[29] ^ ci[30] ^ 
                ci[31];

    assign s6 = typ_parzystosci ^ ci[32] ^ ci[33] ^ ci[34] ^ ci[35] ^ ci[36] ^ ci[37] ^ ci[38];

    // tablica z obliczonymi wartościami bitów syndromu
    wire [6:1] blad_poz;
    assign blad_poz = {s6, s5, s4, s3, s2, s1};
    assign indeks_bledu = blad_poz;


    // detekcja i korekcja błędu, o ile istnieje
    // jesli jakis indeks w tablicy jest != 0, wypisywany jest indeks bledu i inwertowana jest pozycja bledu
    reg [38:1] corrected_code;    
    always @(*) begin
        corrected_code = ci;
        if (blad_poz != 6'b000000) 
        begin
            corrected_code[blad_poz] = ~corrected_code[blad_poz];  
            blad = 1; 
        end
        else begin
            blad = 0; 
        end
        
    end
    assign data_out = corrected_code;  // nadpisany naprawiony ciag 38 bitowy 


    // zdekodowana 32 bitowa liczba do postaci liczby wchodzacej poczatkowo do enkodera
    assign zdekodowane = {ci[38], ci[37], ci[36], ci[35], ci[34], ci[33], ci[31], ci[30], ci[29], ci[28], ci[27], 
    ci[26], ci[25], ci[24], ci[23], ci[22], ci[21], ci[20], ci[19], ci[18], ci[17], ci[15], ci[14], ci[13],
     ci[12], ci[11], ci[10], ci[9], ci[7], ci[6], ci[5], ci[3]};   
endmodule

module hamming_glowne();
    reg [32:1] di;   
    reg typ_parz;     
    wire [38:1] zakodowane;  
    wire p1, p2, p3, p4, p5, p6;
    reg [38:1] ci;
    reg typ_parzystosci;
    wire [38:1] naprawione;
    wire blad;
    wire [6:1] indeks_bledu;  
    wire s1, s2, s3, s4, s5, s6;
    wire [32:1] zdekodowane;   
    integer i;  
    
    hamming_enkoder hmmng1
    (
        .di(di),
        .typ_parz(typ_parz),
        .zakodowane(zakodowane),
        .p1(p1),
        .p2(p2),
        .p3(p3),
        .p4(p4),
        .p5(p5),
        .p6(p6)
    );

    hamming_detekcja_korekcja_dekoder hmmng2
    (
        .ci(ci),
        .typ_parzystosci(typ_parzystosci),
        .data_out(naprawione),
        .blad(blad),
        .indeks_bledu(indeks_bledu),
        .s1(s1),
        .s2(s2),
        .s3(s3),
        .s4(s4),
        .s5(s5),
        .s6(s6),
        .zdekodowane(zdekodowane)
    );
    
    initial begin   
        $display("Symulacja kodu hamminga typu 38,32");
        $display("Enkoder: na wejsciu -> 32 bity informacyjne; na wyjsciu -> 38 bitow (inf i parz) ");
        $display("Detekcja i korekcja 1 bitowych bledow w 38 bitowych slowach kodowych");
        $display("Dekodowanie 38 bitowych slow kodowych do postaci 32 bitowej wiadomosci");
        for (i = 1; i <= 100; i = i + 1) begin
            di = i;
            typ_parz = 0;
            #25;
            $display("Test numer: %d", i);
            $display("Bity informacyjne: %b", di);
            $display("Zakodowana wiadomość: %b", zakodowane);
            $display("Bity parzystości: P1: %b, P2: %b, P3: %b, P4: %b, P5: %b, P6: %b", p1, p2, p3, p4, p5, p6);
            ci = zakodowane ^ 38'b00000000000000000000000000000000000001;
            typ_parzystosci = 0;
            #25;
            $display("Test dekodera z błędem");
            $display("Wiadomość z błędem: %b", ci);
            $display("S1: %b, S2: %b, S3: %b, S4: %b, S5: %b, S6: %b", s1, s2, s3, s4, s5, s6);
            $display("Naprawiona wiadomość: %b", naprawione);
            $display("Indeks błędu: %d", indeks_bledu);
            $display("Zdekodowana liczba: %b", zdekodowane);
            $display("");
        end
        $dumpvars(0, hamming_glowne); 
        $finish; 
    end
    
    initial begin
        $dumpfile("wyniki_hamming.vcd");
        $dumpvars(0, di, typ_parz, zakodowane, p1, p2, p3, p4, p5, p6, ci, typ_parzystosci, blad, naprawione, indeks_bledu, s1, s2, s3, s4, s5, s6,zdekodowane   );
    end
endmodule




