/*
 * SPDX-License-Identifier: Apache-2.0
 */

import {Context, Contract, Info, Returns, Transaction} from 'fabric-contract-api';
import {ChaincodeXFarm} from './chaincodeObjects';
import * as CryptoTS from "crypto-ts";
import { AES } from 'crypto-ts';
@Info({title: 'ChaincodeXFarm', description: 'Smart contract XFarm'})
export class ChaincodeXFarmContract extends Contract {



    // CreateRecord issues a new record to the world state with given details.
    // @Transaction()
    // public async CreateXFarmRecord(ctx: Context, data: string): Promise<string> {
    //     console.log("i am in create fx")
    //     let insertData=JSON.parse(data)
    //     console.log("inserted data :", insertData)

    //     //id to make key
    //     let xfarmId=insertData.xfarm_id

    //     let signatureData=insertData.signature
    //     console.log("ciphext data :",signatureData)

    //     // Encrypt
    //     var ciphertext = CryptoTS.AES.encrypt(signatureData, 'secret key 123');  
    //     console.log("ciphext data :",ciphertext)

    //     let cipherString=ciphertext.toString()
    //     console.log("cipherString data",  cipherString)
    //     console.log("type of cipherString :", typeof cipherString)

    //     delete insertData.xfarm_id;

    //     let hashObj = {
    //             signHash: cipherString
    //         };

    //     const merge = (hashObj, insertData) => {
    //         return {...hashObj, ...insertData};
    //         }
    //     const newData = merge(hashObj, insertData);
    //     console.log("final updated data :- ",newData)

    //     await ctx.stub.putState(xfarmId,Buffer.from(JSON.stringify(newData)));
    //     return "Data successfully added"

    // }

    @Transaction()
    public async CreateXFarmRecord(ctx: Context, data: string): Promise<string> {
        let insertData=JSON.parse(data)
        console.log(" here txnid ",insertData.xfarm_id)
        console.log("insertedData :", insertData)
        //id to make key
        let xfarmId=insertData.xfarm_id

    
        delete insertData.xfarm_id;
       
        await ctx.stub.putState(xfarmId,Buffer.from(JSON.stringify(insertData)));
        return "Data successfully added"
    }

}
