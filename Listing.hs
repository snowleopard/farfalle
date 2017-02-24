{-# LANGUAGE TypeFamilies #-}

module Listing (Listing (..), Register (..), listing) where

import Microprogram
import Control.Monad

data Listing a = Listing a [String] deriving (Eq, Show)

listing :: Listing a -> String
listing (Listing _ ss) = unlines ss

instance Monad Listing where
    return a = Listing a []
    Listing a ss >>= f = Listing result (ss ++ ss')
      where
        Listing result ss' = f a

instance Applicative Listing where
    pure  = return
    (<*>) =  ap

instance Functor Listing where
    fmap = (<$>)

instance Microprogram Listing where
    data Register Listing = Register String
    pc = Register "pc"
    opcode = Register "opcode"
    readMemory address = Listing 0 ["readMemory " ++ show address]
    writeMemory address value = Listing () ["writeMemory " ++ show address ++ " " ++ show value]
    readRegister (Register register) = Listing 0 ["readRegister " ++ register]
    writeRegister (Register register) value = Listing () ["writeRegister " ++ register ++ " " ++ show value]
