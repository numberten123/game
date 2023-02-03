-module(test).

-export([test/0,add_pkcs7_padding/2]).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.


add_pkcs7_padding(UnpaddedDataBin, BlockSize) ->
    PaddingLen0 = erlang:size(UnpaddedDataBin) rem BlockSize,
    PaddingLen = case PaddingLen0 of
        0 -> BlockSize;
        _ -> BlockSize - PaddingLen0
    end,
    Padding = binary:copy(<<PaddingLen/integer>>, PaddingLen),
    <<UnpaddedDataBin/binary, Padding/binary>>.

test() ->
	okk.
%% ===================================================================
%% Unit Tests
%% ===================================================================
-ifdef(TEST).

add_pkcs7_padding_test() ->
    <<1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,1>> = add_pkcs7_padding(<<1,2,3,4,5,6,7,8,9,10,11,12,13,14,15>>, 16),
    <<1,2,3,4,5,6,7,8,9,10,11,12,13,14,2,2>> = add_pkcs7_padding(<<1,2,3,4,5,6,7,8,9,10,11,12,13,14>>, 16),
    <<1,2,3,4,5,6,7,8,9,10,11,12,13,3,3,3>> = add_pkcs7_padding(<<1,2,3,4,5,6,7,8,9,10,11,12,13>>, 16),
    <<1,2,14,14,14,14,14,14,14,14,14,14,14,14,14,14>> = add_pkcs7_padding(<<1,2>>, 16),
    <<1,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15>> = add_pkcs7_padding(<<1>>, 16),
    <<16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16>> = add_pkcs7_padding(<<>>, 16),
    <<1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16>> = add_pkcs7_padding(<<1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16>>, 16),
    <<1,2,3,4,5,6,7,1>> = add_pkcs7_padding(<<1,2,3,4,5,6,7>>, 8),
    <<1,2,3,4,5,6,2,2>> = add_pkcs7_padding(<<1,2,3,4,5,6>>, 8),
    <<1,7,7,7,7,7,7,7>> = add_pkcs7_padding(<<1>>, 8),
    <<1,2,3,4,5,6,7,8,8,8,8,8,8,8,8,8>> = add_pkcs7_padding(<<1,2,3,4,5,6,7,8>>, 8).

-endif.