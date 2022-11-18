import Client from "../src/MinaSigner";
import type { ZkappCommand, Signed } from "../src/TSTypes";

/**
 * This is an example of a zkapp command transaction. This can be generated by
 * creating a transaction in SnarkyJS and printing it out as JSON.
 *
 * TODO: When there is an example of how to do this in the SnarkyJS repo,
 * use that example instead.
 */
let mockedZkappCommand = {
  accountUpdates: [
    {
      body: {
        publicKey: "B62qieh9a3U8Z4s8c3DHhCyDECqyZLyRtGA5GBDMqqi6Lf1gaHX4hLt",
        tokenId: "wSHV2S4qX9jFsLjQo8r1BsMLH2ZRKsZx6EJd1sbozGPieEC4Jf",
        update: {
          appState: ["10", null, null, null, null, null, null, null],
          delegate: null,
          verificationKey: {
            data: "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",
            hash: "14921626286981329856048519544348968231619124872609020581787823194644296594048",
          },
          permissions: {
            editState: "Proof",
            send: "Signature",
            receive: "Proof",
            setDelegate: "Signature",
            setPermissions: "Signature",
            setVerificationKey: "Signature",
            setZkappUri: "Signature",
            editSequenceState: "Proof",
            setTokenSymbol: "Signature",
            incrementNonce: "Signature",
            setVotingFor: "Signature",
          },
          zkappUri: null,
          tokenSymbol: null,
          timing: null,
          votingFor: null,
        },
        balanceChange: { magnitude: "0", sgn: "Positive" },
        incrementNonce: false,
        events: [],
        sequenceEvents: [],
        callData: "0",
        callDepth: 0,
        preconditions: {
          network: {
            snarkedLedgerHash: null,
            blockchainLength: { lower: "0", upper: "4294967295" },
            minWindowDensity: { lower: "0", upper: "4294967295" },
            totalCurrency: { lower: "0", upper: "18446744073709551615" },
            globalSlotSinceGenesis: { lower: "0", upper: "4294967295" },
            stakingEpochData: {
              ledger: {
                hash: null,
                totalCurrency: { lower: "0", upper: "18446744073709551615" },
              },
              seed: null,
              startCheckpoint: null,
              lockCheckpoint: null,
              epochLength: { lower: "0", upper: "4294967295" },
            },
            nextEpochData: {
              ledger: {
                hash: null,
                totalCurrency: { lower: "0", upper: "18446744073709551615" },
              },
              seed: null,
              startCheckpoint: null,
              lockCheckpoint: null,
              epochLength: { lower: "0", upper: "4294967295" },
            },
          },
          account: {
            balance: { lower: "0", upper: "18446744073709551615" },
            nonce: { lower: "0", upper: "4294967295" },
            receiptChainHash: null,
            publicKey: null,
            delegate: null,
            state: [null, null, null, null, null, null, null, null],
            sequenceState: null,
            provedState: null,
            isNew: null,
          },
        },

        useFullCommitment: true,
        caller: "wSHV2S4qX9jFsLjQo8r1BsMLH2ZRKsZx6EJd1sbozGPieEC4Jf",
        authorizationKind: "Signature",
      },
      authorization: {
        proof: null,
        signature:
          "7mX5N5V5mW1HtH6X2bVNadxkqQLtSyDDsp8RSgWxCwweAy2mjjuifxRMcpFNnyru2LerpNtkxrHmHCczyS8uqHpQQXQUzgNF",
      },
    },
  ],
  memo: "E4YM2vTHhWEg66xpj52JErHUBU4pZ1yageL4TVDDpTTSsv8mK6YaH",
};
describe("ZkappCommand", () => {
  let client: Client;

  beforeAll(async () => {
    client = new Client({ network: "mainnet" });
  });

  it("generates a signed zkapp command", () => {
    const keypair = client.genKeys();
    const zkappCommand = client.signZkappCommand(
      {
        zkappCommand: mockedZkappCommand,
        feePayer: {
          feePayer: keypair.publicKey,
          fee: "1",
          nonce: "0",
          memo: "test memo",
        },
      },
      keypair.privateKey
    );
    expect(zkappCommand.data).toBeDefined();
    expect(zkappCommand.signature).toBeDefined();
  });

  it("generates a signed accountUpdate by using signTransaction", () => {
    const keypair = client.genKeys();
    const zkappCommand = client.signTransaction(
      {
        zkappCommand: mockedZkappCommand,
        feePayer: {
          feePayer: keypair.publicKey,
          fee: "1",
          nonce: "0",
          memo: "test memo",
        },
      },
      keypair.privateKey
    ) as Signed<ZkappCommand>;
    expect(zkappCommand.data).toBeDefined();
    expect(zkappCommand.signature).toBeDefined();
  });

  it("should throw an error if no fee is passed to the feePayer", () => {
    const keypair = client.genKeys();
    expect(() => {
      client.signZkappCommand(
        {
          zkappCommand: mockedZkappCommand,
          // @ts-ignore - fee is not defined
          feePayer: {
            feePayer: keypair.publicKey,
            nonce: "0",
            memo: "test memo",
          },
        },
        keypair.privateKey
      );
    }).toThrowError("Fee must be greater than 0.001");
  });

  it("should calculate a correct minimum fee", () => {
    expect(
      client.getAccountUpdateMinimumFee(mockedZkappCommand.accountUpdates, 1)
    ).toBe(1);
  });
});
